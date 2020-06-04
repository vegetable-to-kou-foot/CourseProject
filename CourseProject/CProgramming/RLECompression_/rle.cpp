#include <stdio.h>
#include <stdlib.h>
#include <Windows.h>

#define MAXLENGTH 127

typedef char U8;
typedef unsigned int U32;

int fileReader(char *in_path, U32 &fileSize, char* &fileData)
{
    FILE *fp = NULL;
    int ret;
    fp = fopen(in_path,"rb");
    if (!fp)
    {
        printf("输入文件打开失败");
        return -1;
    }

    int start = ftell(fp);
    ret = fseek(fp,0L,SEEK_END);
    if (ret)
    {
        printf("指针移动出错");
        return -2;
    }
    int end = ftell(fp);
    ret = fseek(fp,0L,SEEK_SET);
    if (ret)
    {
        printf("指针移动出错");
        return -2;
    }
    fileSize = end - start;
    printf("\n该文件大小%u Byte\n",fileSize);

    fileData = (U8*)malloc(sizeof(U8)*fileSize);
    if (!fileData)
    {
        printf("内存申请失败");
        return -3;
    }

    U8 val = 0;
    for (unsigned int i = 0; i < fileSize; i++)
    {
        ret = fread(&val,sizeof(U8),1,fp);
        if (ret == 0)
        {
            printf("文件在第%u Bytes处读取出错",i);
            return -4;
        }
        fileData[i] = val;
    }
    printf("文件读取完成\n");
    fclose(fp);
    return 0;
}


int RLEComp(char *out_path, U32 fileSize, char *fileData)
{
    FILE *fp = NULL;
    fp = fopen(out_path, "wb+");
    if (!fp)
    {
        printf("输出文件打开失败");
        return -1;
    }

    //printf("fileSize=%u\n",fileSize);
    printf("\n压缩进度:[>]");
    //printf("53:%d,54:%d,55:%d,56:%d\n",fileData[53],fileData[54],fileData[55],fileData[56]);

    /* 实验报告中的状态机相关描述有助于理解这段代码，不过这段代码有很强的自解释性 */
    /* 状态0表示“该段数据混乱”，状态1表示“该段数据一致” */
    U32 pt = 0;
    U8 val = 0;
    int state = 0;
    /* pt_last仅用于更新进度条 */
    U32 pt_last = 0;
    while(1)
    {
        /* 用>=可以一定程度上容错 */
        if (pt >= fileSize)
        {
            break;
        }
        /* 特殊情况处理，指针到达最后时，后面的内容足以实现pt+1，因此需要做特判 */
        if (pt == fileSize - 1)
        {
            val = 1;
            fwrite(&val,sizeof(U8),1,fp);
            val = fileData[pt];
            fwrite(&val,sizeof(U8),1,fp);
            break;
        }

        /* 状态i开始 */
        int pt_end = 0;
        state = fileData[pt] == fileData[pt+1] ? 1 : 0;
        //printf("state = %d\n",state);
        for (int i = 0; i < MAXLENGTH; i++)
        {
            int state_tmp = fileData[pt+i] == fileData[pt+i+1] ? 1 : 0;
            //printf("state_tmp = %d,i=%d\n",state_tmp,i);
            /* 出现了不同的状态 */
            if (state != state_tmp)
            {
                /* 指针放到不一致开始的位置处 */
                pt_end = pt + i + 1;
                /* 数据段开头写入该段长度，若为“一致段”，则要额外增加128，使得长度信息最高位为1 */
                int tmp = state == 1 ? 128 : 0;
                val = pt_end - pt + tmp;
                fwrite(&val,sizeof(U8),1,fp);
                /* 将该段数据存储至输出文件中 */
                if (state == 1)
                {
                    val = fileData[pt];
                    fwrite(&val,sizeof(U8),1,fp);
                }
                else
                {
                    for (int j = pt; j < pt_end; j++)
                    {
                        val = fileData[j];
                        fwrite(&val,sizeof(U8),1,fp);
                    }
                }
                pt_last = pt;
                pt = pt_end;
                break;
            }
            /* 该段到结尾了都保持同样的状态 */
            if (i == MAXLENGTH - 1)
            {
                //printf("In MAXLENGTH,pt = %d\n",pt);
                /* 指针放到不一致开始的位置处 */
                pt_end = pt + MAXLENGTH;
                /* 数据段开头写入该段长度，若为“一致段”，则要额外增加128，使得长度信息最高位为1 */
                int tmp = state == 1 ? 128 : 0;
                val = pt_end - pt + tmp;
                fwrite(&val,sizeof(U8),1,fp);
                /* 将该段数据存储至输出文件中 */
                if (state == 1)
                {
                    val = fileData[pt];
                    fwrite(&val,sizeof(U8),1,fp);
                }
                else
                {
                    for (int j = pt; j < pt_end; j++)
                    {
                        val = fileData[j];
                        fwrite(&val,sizeof(U8),1,fp);
                    }
                }
                pt_last = pt;
                pt = pt_end;
                break;
            }
            /* 在得到当前段状态码之前就出错的情况已经在外部处理，这里只要处理走到一半发现文件结束的情况 */
            /* 能走到这里说明该段之前状态都是一致的 */
            if (i != 0 && pt + i == fileSize - 1)
            {
                /* 指针放到不一致开始的位置处 */
                pt_end = fileSize;
                /* 数据段开头写入该段长度，若为“一致段”，则要额外增加128，使得长度信息最高位为1 */
                int tmp = state == 1 ? 128 : 0;
                val = pt_end - pt + tmp;
                fwrite(&val,sizeof(U8),1,fp);
                /* 将该段数据存储至输出文件中 */
                if (state == 1)
                {
                    val = fileData[pt];
                    fwrite(&val,sizeof(U8),1,fp);
                }
                else
                {
                    for (int j = pt; j < pt_end; j++)
                    {
                        val = fileData[j];
                        fwrite(&val,sizeof(U8),1,fp);
                    }
                }
                pt_last = pt;
                pt = pt_end;
                break;
            }
        }

        int prog = pt * 10 / fileSize;
        int prog_last = pt_last*10/fileSize;
        for (int i = 0; i < prog_last+2; i++)
        {
            printf("\b");
        }
        for (int i = 0; i < prog; i++)
        {
            printf("=");
        }
        printf(">]");
        //printf("pt = %u\n",pt);
    }

    fclose(fp);
    return 0;
}


int unpackComp(char *unpack_path, U32 fileSize, char *fileData)
{
    FILE *fp = NULL;
    fp = fopen(unpack_path, "wb");
    if (!fp)
    {
        printf("输出文件打开失败");
        return -1;
    }

    if (fileData == NULL)
    {
        printf("数据读取失败");
        return -1;
    }

    printf("\n解压进度:[>]");

    U8 val = 0;
    U32 pt = 0;
    U32 pt_last = 0;
    U32 len = 0;
    int needCopy = 0;
    while(1)
    {
        if (pt == fileSize)
        {
            break;
        }
        pt_last = pt;

        if ((fileData[pt] & 0x80) == 0)
        {
            needCopy = 0;
            len = fileData[pt];
        }
        else
        {
            needCopy = 1;
            len = fileData[pt] & 0x7F;
        }
        /*printf("fd[pt] = %d%d%d%d %d%d%d%d\n",(fileData[pt]&0x80)/0x80,(fileData[pt]&0x40)/0x40,(fileData[pt]&0x20)/0x20,(fileData[pt]&0x10)/0x10,
               (fileData[pt]&0x08)/0x08,(fileData[pt]&0x04)/0x04,(fileData[pt]&0x02)/0x02,(fileData[pt]&0x01)/0x01);*/
        //printf("pt = %d,len = %u\n",pt,len);
        pt++;
        if (needCopy)
        {
            val = fileData[pt];
            for (U32 i = 0; i< len; i++)
            {
                fwrite(&val,sizeof(U8),1,fp);
            }
            pt++;
        }
        else
        {
            for (U32 i = 0; i< len; i++)
            {
                val = fileData[pt+i];
                fwrite(&val,sizeof(U8),1,fp);
            }
            pt += len;
        }

        int prog = pt * 10 / fileSize;
        int prog_last = pt_last*10/fileSize;
        for (int i = 0; i < prog_last+2; i++)
        {
            printf("\b");
        }
        for (int i = 0; i < prog; i++)
        {
            printf("=");
        }
        printf(">]");
        //printf("pt=%u\n",pt);
    }

    fclose(fp);
    return 0;
}


int main(int argc, char *argv[])
{
    U32 fileSize = 0;
    char *in_path = NULL;
    char *out_path = NULL;
    char *fileData = NULL;
    int err = 0;
    
	char op = argv[2][1];
    if (op == 'c')
    {
    	in_path = argv[1];
    	out_path = argv[3];
	    err = fileReader(in_path, fileSize, fileData);
	    if (err)
	    {
	        return -1;
	    }
	
	    err = RLEComp(out_path, fileSize, fileData);
	    if (err)
	    {
	        return -1;
	    }
	
	    free(fileData);
	}
	else if(op == 'd')
	{
		in_path = argv[1];
    	out_path = argv[3];
	    err = fileReader(in_path, fileSize, fileData);
	    if (err)
	    {
	        return -1;
	    }
	
	    err = unpackComp(out_path, fileSize, fileData);
	    if (err)
	    {
	        return -1;
	    }
	
	    free(fileData);
	}

    return 0;
}
