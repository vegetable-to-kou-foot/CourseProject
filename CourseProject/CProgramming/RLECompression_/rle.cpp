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
        printf("�����ļ���ʧ��");
        return -1;
    }

    int start = ftell(fp);
    ret = fseek(fp,0L,SEEK_END);
    if (ret)
    {
        printf("ָ���ƶ�����");
        return -2;
    }
    int end = ftell(fp);
    ret = fseek(fp,0L,SEEK_SET);
    if (ret)
    {
        printf("ָ���ƶ�����");
        return -2;
    }
    fileSize = end - start;
    printf("\n���ļ���С%u Byte\n",fileSize);

    fileData = (U8*)malloc(sizeof(U8)*fileSize);
    if (!fileData)
    {
        printf("�ڴ�����ʧ��");
        return -3;
    }

    U8 val = 0;
    for (unsigned int i = 0; i < fileSize; i++)
    {
        ret = fread(&val,sizeof(U8),1,fp);
        if (ret == 0)
        {
            printf("�ļ��ڵ�%u Bytes����ȡ����",i);
            return -4;
        }
        fileData[i] = val;
    }
    printf("�ļ���ȡ���\n");
    fclose(fp);
    return 0;
}


int RLEComp(char *out_path, U32 fileSize, char *fileData)
{
    FILE *fp = NULL;
    fp = fopen(out_path, "wb+");
    if (!fp)
    {
        printf("����ļ���ʧ��");
        return -1;
    }

    //printf("fileSize=%u\n",fileSize);
    printf("\nѹ������:[>]");
    //printf("53:%d,54:%d,55:%d,56:%d\n",fileData[53],fileData[54],fileData[55],fileData[56]);

    /* ʵ�鱨���е�״̬��������������������δ��룬������δ����к�ǿ���Խ����� */
    /* ״̬0��ʾ���ö����ݻ��ҡ���״̬1��ʾ���ö�����һ�¡� */
    U32 pt = 0;
    U8 val = 0;
    int state = 0;
    /* pt_last�����ڸ��½����� */
    U32 pt_last = 0;
    while(1)
    {
        /* ��>=����һ���̶����ݴ� */
        if (pt >= fileSize)
        {
            break;
        }
        /* �����������ָ�뵽�����ʱ���������������ʵ��pt+1�������Ҫ������ */
        if (pt == fileSize - 1)
        {
            val = 1;
            fwrite(&val,sizeof(U8),1,fp);
            val = fileData[pt];
            fwrite(&val,sizeof(U8),1,fp);
            break;
        }

        /* ״̬i��ʼ */
        int pt_end = 0;
        state = fileData[pt] == fileData[pt+1] ? 1 : 0;
        //printf("state = %d\n",state);
        for (int i = 0; i < MAXLENGTH; i++)
        {
            int state_tmp = fileData[pt+i] == fileData[pt+i+1] ? 1 : 0;
            //printf("state_tmp = %d,i=%d\n",state_tmp,i);
            /* �����˲�ͬ��״̬ */
            if (state != state_tmp)
            {
                /* ָ��ŵ���һ�¿�ʼ��λ�ô� */
                pt_end = pt + i + 1;
                /* ���ݶο�ͷд��öγ��ȣ���Ϊ��һ�¶Ρ�����Ҫ��������128��ʹ�ó�����Ϣ���λΪ1 */
                int tmp = state == 1 ? 128 : 0;
                val = pt_end - pt + tmp;
                fwrite(&val,sizeof(U8),1,fp);
                /* ���ö����ݴ洢������ļ��� */
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
            /* �öε���β�˶�����ͬ����״̬ */
            if (i == MAXLENGTH - 1)
            {
                //printf("In MAXLENGTH,pt = %d\n",pt);
                /* ָ��ŵ���һ�¿�ʼ��λ�ô� */
                pt_end = pt + MAXLENGTH;
                /* ���ݶο�ͷд��öγ��ȣ���Ϊ��һ�¶Ρ�����Ҫ��������128��ʹ�ó�����Ϣ���λΪ1 */
                int tmp = state == 1 ? 128 : 0;
                val = pt_end - pt + tmp;
                fwrite(&val,sizeof(U8),1,fp);
                /* ���ö����ݴ洢������ļ��� */
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
            /* �ڵõ���ǰ��״̬��֮ǰ�ͳ��������Ѿ����ⲿ��������ֻҪ�����ߵ�һ�뷢���ļ���������� */
            /* ���ߵ�����˵���ö�֮ǰ״̬����һ�µ� */
            if (i != 0 && pt + i == fileSize - 1)
            {
                /* ָ��ŵ���һ�¿�ʼ��λ�ô� */
                pt_end = fileSize;
                /* ���ݶο�ͷд��öγ��ȣ���Ϊ��һ�¶Ρ�����Ҫ��������128��ʹ�ó�����Ϣ���λΪ1 */
                int tmp = state == 1 ? 128 : 0;
                val = pt_end - pt + tmp;
                fwrite(&val,sizeof(U8),1,fp);
                /* ���ö����ݴ洢������ļ��� */
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
        printf("����ļ���ʧ��");
        return -1;
    }

    if (fileData == NULL)
    {
        printf("���ݶ�ȡʧ��");
        return -1;
    }

    printf("\n��ѹ����:[>]");

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
