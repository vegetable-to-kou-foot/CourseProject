/************************************
 Author:        17010150014 ������
 Date:          2020/5/29
 Description:   �ó���ʵ���˷Ŵ�ͼ��Ĺ��� 
*************************************/

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

typedef char U8;
typedef unsigned short U16;
typedef unsigned int U32;

/* һ��Ҫ��1�ֽڶ��룬�����޷���ȷ��ȡ */
# pragma pack (1)
typedef struct
{
	U16    bfType;
	U32    bfSize;
	U16    bfReserved1;
	U16    bfReserved2;
	U32    bfOffBits;
} BitMapFileHeader;

typedef struct
{
	U32  biSize;
	U32   biWidth;
	U32   biHeight;
	U16   biPlanes;
	U16   biBitCount;
	U32  biCompression;
	U32  biSizeImage;
	U32   biXPelsPerMeter;
	U32   biYPelsPerMeter;
	U32   biClrUsed;
	U32   biClrImportant;
} BitMapInfoHeader;

typedef struct
{
	U8 rgbBlue;
	U8 rgbGreen;
	U8 rgbRed;
	U8 rgbReserved;
} RgbQuad;
# pragma pack ()


int solve(char* in_path, char *out_path, double scale);
U8 get_pixel(U8 *imageData, int i, int j, double scale, int height, int width, int step, int channels, int ch);
U8 get_pixel_8(U8 *imageData, int i, int j, double scale, int height, int width, int step);


int main(int argc, char *argv[])
{
	printf("λͼ�Ŵ󹤾�\nAuthor��17010150014 ������\n");
    double scale = atof(argv[2])/100.0;
    if (scale < 0)
    {
    	printf("�Ŵ�߶ȱ������0\n");
	}
    int flag = solve(argv[1],argv[3],scale);
	if(flag)
	{
		printf("read and save ok... \n");
	}
	return 0;
}


/**
*@ Descrption:��ȡԭͼ����Ӧλ�õ����� 
* @Param imageData:ԭͼ������
* @Param i,j:���ͼ�������λ��
* @Param scale:���ų߶� 
* @Param height,width:ԭͼ��߶ȡ���� 
* @Param step:ԭͼ��������һ�еĳ��ȣ�����䣩 
* @Param channels:ͼ��ͨ���� 
* @Param ch:һ��ͨ���ڵ�ƫ����������ָʾRGBA��λ�� 
* @Return :����ֵ������ΪU8 
*/
U8 get_pixel(U8 *imageData, int i, int j, double scale, int height, int width, int step, int channels, int ch)
{
    i /= scale;
    j /= scale;
    if ((int)i == height - 1 || (int)j == width - 1)
    {
        return (U8)imageData[ (height - 1 - (int)i)*step + (int)j*channels + ch];
    }

    double s1 = i - (int)i;
    double s4 = j - (int)j;
    double s3 = 1 - s1;
    double s2 = 1 - s4;
    i = (int)i;
    j = (int)j;
    U8 v1 = imageData[ (height - 1 - i)*step + j*channels + ch ];
    U8 v2 = imageData[ (height - 1 - i)*step + (j+1)*channels + ch ];
    U8 v3 = imageData[ (height - 2 - i)*step + j*channels + ch ];
    U8 v4 = imageData[ (height - 2 - i)*step + (j+1)*channels + ch ];
    return (U8)(v1*s1*s4 + v2*s1*s2 + v3*s3*s4 + v4*s2*s3);
}


U8 get_pixel_8(U8 *imageData, int i, int j, double scale, int height, int width, int step)
{
    i /= scale;
    j /= scale;
    if ((int)i == height - 1 || (int)j == width - 1)
    {
        return (U8)imageData[ (height - 1 - (int)i)*step + (int)j];
    }

    double s1 = i - (int)i;
    double s4 = j - (int)j;
    double s3 = 1 - s1;
    double s2 = 1 - s4;
    i = (int)i;
    j = (int)j;
    U8 v1 = imageData[ (height - 1 - i)*step + j ];
    U8 v2 = imageData[ (height - 1 - i)*step + (j+1) ];
    U8 v3 = imageData[ (height - 2 - i)*step + j ];
    U8 v4 = imageData[ (height - 2 - i)*step + (j+1) ];
    if (s1 < 0.5 && s4 <= 0.5)
    {
    	return v1;
	}
	else if (s1 < 0.5 && s2 < 0.5)
    {
    	return v2;
	}
	else if (s3 <= 0.5 && s4 <= 0.5)
    {
    	return v3;
	}
	else if (s2 < 0.5 && s3 <= 0.5)
    {
    	return v4;
	}
}


/**
*@ Descrption:�������������� 
* @Param in_path:ԭͼ��λ��
* @Param out_path:���ͼ��λ��
* @Param scale:���ų߶� 
* @Return flag:1:����ִ�гɹ�;0:����ִ��ʧ�� 
*/
int solve(char* in_path, char *out_path, double scale)
{
    /* ��ȡ���� */

	FILE* pFile = NULL;
	BitMapFileHeader bmpFileHeader;
	BitMapInfoHeader bmpInfoHeader;
	/* ���ڴ�������������� */
	U8 *imageData = 0;
	int channels = 1;
	int width = 0;
	int height = 0;
	int step = 0;
	int offset = 0;
	/* ���Ƶ�ɫ���ж��ٸ�4Bytes */
	int rate = 0;
	U8 pixVal;
	RgbQuad* quad;

	pFile = fopen(in_path, "rb");
	if (!pFile)
	{
		printf("����ͼ���ʧ��"); 
		return 0;
	}

	fread(&bmpFileHeader, sizeof(BitMapFileHeader), 1, pFile);
	fread(&bmpInfoHeader, sizeof(BitMapInfoHeader), 1, pFile);
	printf("%x\n",bmpFileHeader.bfType);
	if (bmpFileHeader.bfType == 0x4D42)
	{
		printf("bmp file! \n");

		printf("����ͼ��ͷ��\n");
		printf("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n");
		printf("bmp�ļ�ͷ��Ϣ��\n");
		printf("�ļ���С��%d \n", bmpFileHeader.bfSize);
		printf("�����֣�%d \n", bmpFileHeader.bfReserved1);
		printf("�����֣�%d \n", bmpFileHeader.bfReserved2);
		printf("λͼ����ƫ���ֽ�����%d \n", bmpFileHeader.bfOffBits);

		printf("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n");
		printf("bmp�ļ���Ϣͷ\n");
		printf("�ṹ�峤�ȣ�%d \n", bmpInfoHeader.biSize);
		printf("λͼ��ȣ�%d \n", bmpInfoHeader.biWidth);
		printf("λͼ�߶ȣ�%d \n", bmpInfoHeader.biHeight);
		printf("λͼƽ������%d \n", bmpInfoHeader.biPlanes);
		printf("��ɫλ����%d \n", bmpInfoHeader.biBitCount);
		printf("ѹ����ʽ��%d \n", bmpInfoHeader.biCompression);
		printf("ʵ��λͼ����ռ�õ��ֽ�����%d \n", bmpInfoHeader.biSizeImage);
		printf("X����ֱ��ʣ�%d \n", bmpInfoHeader.biXPelsPerMeter);
		printf("Y����ֱ��ʣ�%d \n", bmpInfoHeader.biYPelsPerMeter);
		printf("ʹ�õ���ɫ����%d \n", bmpInfoHeader.biClrUsed);
		printf("��Ҫ��ɫ����%d \n", bmpInfoHeader.biClrImportant);
		printf("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n");

		if (bmpInfoHeader.biBitCount == 1 || bmpInfoHeader.biBitCount == 4 || bmpInfoHeader.biBitCount == 8)
		{
			width = bmpInfoHeader.biWidth;
			height = bmpInfoHeader.biHeight;

			offset = width%4;
			if (offset != 0)
			{
				offset = 4 - offset;
			}
			step = width + offset;
			imageData = (U8*)malloc(sizeof(U8)*step*height);
			
			rate = 0;
			switch(bmpInfoHeader.biBitCount)
			{
				case 1:rate = 2;break;
				case 4:rate = 16;break;
				case 8:rate = 256;break;
			}

			quad = (RgbQuad*)malloc(sizeof(RgbQuad)*rate);
			fread(quad, sizeof(RgbQuad), rate, pFile);

			for (int i=0; i<height; i++)
			{
				for (int j=0; j<width; j++)
				{
					fread(&pixVal, sizeof(U8), 1, pFile);
					imageData[i*step+j] = pixVal;
				}
				for (int j=0; j<offset; j++)
				{
					fread(&pixVal, sizeof(U8), 1, pFile);
				}
			}
		}
		else if (bmpInfoHeader.biBitCount == 24 || bmpInfoHeader.biBitCount == 32)
		{
			channels = bmpInfoHeader.biBitCount / 8;
			width = bmpInfoHeader.biWidth;
			height = bmpInfoHeader.biHeight;


			offset = (channels*width)%4;
			if (offset != 0)
			{
				offset = 4 - offset;
			}
			step = width*channels + offset;

			imageData = (U8*)malloc(sizeof(U8)*height*step);
			memset(imageData,0,sizeof(U8)*height*step);

			for (int i=0; i<height; i++)
			{
				for (int j=0; j<width; j++)
				{
					for (int k=0; k<channels; k++)
					{
						fread(&pixVal, sizeof(U8), 1, pFile);
						imageData[i*step+j*channels+k] = pixVal;
					}
				}
				for (int j=0; j<offset; j++)
				{
					fread(&pixVal, sizeof(U8), 1, pFile);
				}
			}
		}
	}


	fclose(pFile);


	/* д������ */

	int step_backup = step;
    int width_backup = width;
    int height_backup = height;
	width = (int)(width*scale);
	height = (int)(height*scale);

	pFile = fopen(out_path, "wb");
	if (!pFile)
	{
		printf("���ͼ���ʧ��\n");
		return 0;
	}

	if (channels == 3 || channels == 4)
	{
		offset = (channels*width)%4;
		if (offset != 0)
		{
			offset = 4 - offset;
		}
		step = channels*width + offset;

		bmpFileHeader.bfSize = height*step + 54;
		/*bmpFileHeader.bfReserved1 = 0;
		bmpFileHeader.bfReserved2 = 0;
		bmpFileHeader.bfOffBits = 54;*/
		fwrite(&bmpFileHeader, sizeof(BitMapFileHeader), 1, pFile);

		/*bmpInfoHeader.biSize = 40;*/
		bmpInfoHeader.biWidth = width;
		bmpInfoHeader.biHeight = height;
		/*bmpInfoHeader.biPlanes = 1;
		bmpInfoHeader.biBitCount = 32;
		bmpInfoHeader.biCompression = 0;*/
		bmpInfoHeader.biSizeImage = height*step;
		/*bmpInfoHeader.biXPelsPerMeter = 0;
		bmpInfoHeader.biYPelsPerMeter = 0;
		bmpInfoHeader.biClrUsed = 0;
		bmpInfoHeader.biClrImportant = 0;*/
		fwrite(&bmpInfoHeader, sizeof(BitMapInfoHeader), 1, pFile);

		printf("���ͼ��ͷ��\n");
		printf("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n");
		printf("bmp�ļ�ͷ��Ϣ��\n");
		printf("�ļ���С��%d \n", bmpFileHeader.bfSize);
		printf("�����֣�%d \n", bmpFileHeader.bfReserved1);
		printf("�����֣�%d \n", bmpFileHeader.bfReserved2);
		printf("λͼ����ƫ���ֽ�����%d \n", bmpFileHeader.bfOffBits);

		printf("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n");
		printf("bmp�ļ���Ϣͷ\n");
		printf("�ṹ�峤�ȣ�%d \n", bmpInfoHeader.biSize);
		printf("λͼ��ȣ�%d \n", bmpInfoHeader.biWidth);
		printf("λͼ�߶ȣ�%d \n", bmpInfoHeader.biHeight);
		printf("λͼƽ������%d \n", bmpInfoHeader.biPlanes);
		printf("��ɫλ����%d \n", bmpInfoHeader.biBitCount);
		printf("ѹ����ʽ��%d \n", bmpInfoHeader.biCompression);
		printf("ʵ��λͼ����ռ�õ��ֽ�����%d \n", bmpInfoHeader.biSizeImage);
		printf("X����ֱ��ʣ�%d \n", bmpInfoHeader.biXPelsPerMeter);
		printf("Y����ֱ��ʣ�%d \n", bmpInfoHeader.biYPelsPerMeter);
		printf("ʹ�õ���ɫ����%d \n", bmpInfoHeader.biClrUsed);
		printf("��Ҫ��ɫ����%d \n", bmpInfoHeader.biClrImportant);
		printf("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n");

		/* ע����µ������ */
		for (int i=height-1; i>=0; i--)
		{
			for (int j=0; j<width; j++)
			{
			    for (int ch = 0; ch < channels; ch++)
                {
                    pixVal = get_pixel(imageData, i, j, scale, height_backup, width_backup, step_backup, channels, ch);
                    fwrite(&pixVal, sizeof(U8), 1, pFile);
                }
			}
            for (int j=0; j<offset; j++)
            {
                pixVal = 0;
                fwrite(&pixVal, sizeof(U8), 1, pFile);
            }
		}
	}
	else if (channels == 1)
	{
		offset = width%4;
		if (offset != 0)
		{
			offset = 4 - offset;
		}
		step = width + offset;
		
		bmpFileHeader.bfSize = 54 + rate*4 + step*height;
		/*bmpFileHeader.bfReserved1 = 0;
		bmpFileHeader.bfReserved2 = 0;
		bmpFileHeader.bfOffBits = 54 + rate*4;*/
		fwrite(&bmpFileHeader, sizeof(BitMapFileHeader), 1, pFile);

		/*bmpInfoHeader.biSize = 40;*/
		bmpInfoHeader.biWidth = width;
		bmpInfoHeader.biHeight = height;
		/*bmpInfoHeader.biPlanes = 1;
		bmpInfoHeader.biBitCount = 8;
		bmpInfoHeader.biCompression = 0;*/
		bmpInfoHeader.biSizeImage = step*height;
		/*bmpInfoHeader.biXPelsPerMeter = 0;
		bmpInfoHeader.biYPelsPerMeter = 0;
		bmpInfoHeader.biClrUsed = 256;
		bmpInfoHeader.biClrImportant = 256;*/
		fwrite(&bmpInfoHeader, sizeof(BitMapInfoHeader), 1, pFile);

		fwrite(quad, sizeof(RgbQuad), rate, pFile);
		
		printf("���ͼ��ͷ��\n");
		printf("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n");
		printf("bmp�ļ�ͷ��Ϣ��\n");
		printf("�ļ���С��%d \n", bmpFileHeader.bfSize);
		printf("�����֣�%d \n", bmpFileHeader.bfReserved1);
		printf("�����֣�%d \n", bmpFileHeader.bfReserved2);
		printf("λͼ����ƫ���ֽ�����%d \n", bmpFileHeader.bfOffBits);

		printf("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n");
		printf("bmp�ļ���Ϣͷ\n");
		printf("�ṹ�峤�ȣ�%d \n", bmpInfoHeader.biSize);
		printf("λͼ��ȣ�%d \n", bmpInfoHeader.biWidth);
		printf("λͼ�߶ȣ�%d \n", bmpInfoHeader.biHeight);
		printf("λͼƽ������%d \n", bmpInfoHeader.biPlanes);
		printf("��ɫλ����%d \n", bmpInfoHeader.biBitCount);
		printf("ѹ����ʽ��%d \n", bmpInfoHeader.biCompression);
		printf("ʵ��λͼ����ռ�õ��ֽ�����%d \n", bmpInfoHeader.biSizeImage);
		printf("X����ֱ��ʣ�%d \n", bmpInfoHeader.biXPelsPerMeter);
		printf("Y����ֱ��ʣ�%d \n", bmpInfoHeader.biYPelsPerMeter);
		printf("ʹ�õ���ɫ����%d \n", bmpInfoHeader.biClrUsed);
		printf("��Ҫ��ɫ����%d \n", bmpInfoHeader.biClrImportant);
		printf("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n");

		for (int i=height-1; i>=0; i--)
		{
			for (int j=0; j<width; j++)
			{
				pixVal = get_pixel_8(imageData, i, j, scale, height_backup, width_backup, step_backup);
				fwrite(&pixVal, sizeof(U8), 1, pFile);
			}
			for (int j=0; j<offset; j++)
            {
                pixVal = 0;
                fwrite(&pixVal, sizeof(U8), 1, pFile);
            }
		}
		free(quad);
	}
	fclose(pFile);
	free(imageData);

	return 1;

}

