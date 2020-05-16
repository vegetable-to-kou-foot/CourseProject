/************************************
 Author:        17010150014 ������
 Date:          2020/5/16
 Description:   �ó���ʵ�ָ߾��ȼӼ���
*************************************/

/* sscanf_sʹ��ǰ��Ҫ���壬�μ� https://zh.cppreference.com/w/c/io/fscanf */
#define __STDC_WANT_LIB_EXT1__ 1

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef MAXSIZE
#define MAXSIZE 10000
#endif /* MAXSIZE */


int high_precision_compare(int *a,int *b);
int *high_precision_sub(int *a,int *b);
int *high_precision_add(int *a,int *b);


int main()
{
    char input_string[2 * MAXSIZE + 1],input_string_1[MAXSIZE],input_string_2[100],input_string_3[MAXSIZE];
    printf("�߾��ȼ��㹤��\nAuthor��17010150014 ������\n�˳������밴ctrl+Z+2��enter��\n");
    printf("������x +/- y����enter��ʼ���㣬���ʽǰ��Ӧ�пո�\n");
    while(1)
    {
        printf("\n---------------------------------------------\n");
        int in = scanf("%[^\n]",input_string);
        /* �����������C Primer���Ƽ���д�������ϻ�Ϊ��C���Ա�̹淶����˽��䰴�淶��д */
        char c;
        while(1)
        {
            c = getchar();
            if (!(c != EOF && c != '\n'))
            {
                break;
            }
        }

        if (in == EOF)
        {
            break;
        }
        else if(in != 1)
        {
            printf("�����ʽ���󣬶�ȡʧ��\n");
            continue;
        }


        /* ����û������Ƿ���������ַ� */
        int input_str_len = strlen(input_string);
        int toNext = 0;
        for (int i = 0; i < input_str_len; i++)
        {
            if (!((input_string[i] >= '0' && input_string[i] <= '9') ||
                input_string[i] == '+' || input_string[i] == '-' || input_string[i] == ' '))
            {
                printf("���ڷǷ��ַ�\n");
                toNext = 1;
                break;
            }
        }
        if (toNext)
        {
            continue;
        }

        /* ��������������������˴����μ���û������Ƿ���ȱʧ�Ĳ��֡�����ͷ��β���ڿո�Ҳ�����ʧ�ܡ� */
        memset(input_string_1,0,MAXSIZE);
        memset(input_string_2,0,100);
        memset(input_string_3,0,MAXSIZE);
        /* ���ݻ�ΪC��̹淶��ʹ�ð�ȫ�����뺯���� */
        /* ��������ж��ܷ�ʹ��sscanf_s���μ� https://zh.cppreference.com/w/c/io/fscanf */
        #ifdef __STDC_LIB_EXT1__
        sscanf_s(input_string,"%[0-9]%*[+- ]%*[0-9]",input_string_1,MAXSIZE-1);
        sscanf_s(input_string,"%*[0-9 ]%[+-]%*[0-9]",input_string_2,100-1);
        sscanf_s(input_string,"%*[0-9]%*[ +-]%[0-9]",input_string_3,MAXSIZE-1);
        #else
        sscanf(input_string,"%[0-9]%*[+- ]%*[0-9]",input_string_1);
        sscanf(input_string,"%*[0-9 ]%[+-]%*[0-9]",input_string_2);
        sscanf(input_string,"%*[0-9]%*[ +-]%[0-9]",input_string_3);
        #endif
        if (strlen(input_string_1) == 0 || strlen(input_string_2) == 0 || strlen(input_string_3) == 0)
        {
            printf("���ʽȱ�ٳɷ֣��������ʽ���󣬱��ʽǰ��Ӧ�пո�\n");
            continue;
        }


        int input_int_1[MAXSIZE+1],input_int_2[MAXSIZE+1];

        /* �˴������Ǳ�Ҫ�ģ����������������һ�μ�������Ӱ����һ�����㡣 */
        memset(input_int_1,0,sizeof(int)*(MAXSIZE+1));
        memset(input_int_2,0,sizeof(int)*(MAXSIZE+1));

        char op = 0;
        input_int_1[0] = strlen(input_string_1);
        input_int_2[0] = strlen(input_string_3);
        for (int i = 1 ; i <= input_int_1[0] ; i++)
        {
            input_int_1[i] = input_string_1[input_int_1[0] - i] - '0';
        }
        for (int i = 1 ; i <= input_int_2[0] ; i++)
        {
            input_int_2[i] = input_string_3[input_int_2[0] - i] - '0';
        }

        /* �����ַ������ȣ���С��1ʱ���ټ�����С�� */
        while(input_int_1[input_int_1[0]] == 0 && input_int_1[0] != 1)
        {
            input_int_1[0]--;
        }
        while(input_int_2[input_int_2[0]] == 0 && input_int_2[0] != 1)
        {
            input_int_2[0]--;
        }

        op = input_string_2[0];

        int *ans = NULL;
        if (op == '+')
        {
            ans = high_precision_add(input_int_1,input_int_2);
        }
        else if(op == '-')
        {
            ans = high_precision_sub(input_int_1,input_int_2);
        }
        else
        {
            printf("û�м�⵽������\n");
            continue;
        }

        if (ans == NULL)
        {
            printf("�����������������\n");
            continue;
        }

        /* ��ans[0]Ϊ����˵�����Ϊ�����˴���Ҫ�������������������ʾ������ */
        printf("answer = ");
        if (ans[0] < 0)
        {
            printf("-");
            ans[0] = -ans[0];
        }

        char output_string[MAXSIZE+2];
        for (int i = 1; i <= ans[0]; i++)
        {
            output_string[ans[0] - i] = ans[i] + '0';
        }
        output_string[ans[0]] = 0;

        /* ���������ͷ��ڴ棬�ͷ�֮��Ҫ��ֹҰָ�� */
        free(ans);
        ans = NULL;
        printf("%s\n",output_string);
    }
    return 0;
}


/**
*@ Descrption:�߾��ȱȽ�
* @Param a:���飬����ΪMAXSIZE+1��a[0]��¼������ĳ���
* @Param b:���飬����ΪMAXSIZE+1��b[0]��¼������ĳ���
* @Return 1:a<b ; 0:a==b ; -1:a>b
*/
int high_precision_compare(int *a,int *b)
{
    /* �ȱȳ��� */
    if (a[0] > b[0])
    {
        return 1;
    }
    else if(a[0] < b[0])
    {
        return -1;
    }
    else
    {
        /* ����һ���ٴӸ�λ����λ�Ƚ� */
        for (int i = a[0] ; i >= 1 ; i--)
        {
            if (a[i] > b[i])
            {
                return 1;
            }
            else if(a[i] < b[i])
            {
                return -1;
            }
        }
        /* ��ȫһ�������0 */
        return 0;
    }
}


/**
*@ Descrption:�߾��ȼ���
* @Param a:���飬����ΪMAXSIZE+1��a[0]��¼������ĳ���
* @Param b:���飬����ΪMAXSIZE+1��b[0]��¼������ĳ���
* @Return ans:���飬����ΪMAXSIZE+1��ans[0]��¼������ĳ���
*/
int *high_precision_sub(int *a,int *b)
{
    int max_len = a[0] > b[0] ? a[0] : b[0];
    /* ��Ҫ��ans[0]���泤�ȣ����Ҫ������1��int�Ŀռ� */
    int *ans = (int *)malloc(sizeof(int) * (max_len + 1));
    if (ans == NULL)
    {
        printf("�ڴ����ʧ�ܣ�\n");
        return NULL;
    }
    memset(ans,0,sizeof(int) * (max_len + 1));

    int cmp = high_precision_compare(a,b);
    if (cmp == 0)
    {
        ans[0] = 1;
        ans[1] = 0;
        return ans;
    }
    else if(cmp == 1)
    {
        for (int i = 0; i<= a[0]; i++)
        {
            ans[i] = a[i];
        }
        for (int i = 1 ; i <= ans[0] ; i++)
        {
            /* ������Ҫ��λ */
            if (ans[i] < b[i])
            {
                ans[i+1]--;
                ans[i] += 10;
            }
            ans[i] = ans[i] - b[i];
        }
        /* ����λ�� */
        while(ans[ans[0]] == 0 && ans[0] != 1)
        {
            ans[0]--;
        }
        return ans;
    }
    else if(cmp == -1)
    {
        for (int i = 0; i<= b[0]; i++)
        {
            ans[i] = b[i];
        }
        for (int i = 1 ; i <= ans[0] ; i++)
        {
            if (ans[i] < a[i])
            {
                ans[i+1]--;
                ans[i] += 10;
            }
            ans[i] = ans[i] - a[i];
        }
        while(ans[ans[0]] == 0 && ans[0] != 1)
        {
            ans[0]--;
        }
        ans[0] = -ans[0];
        return ans;
    }
    return NULL;
}


/**
*@ Descrption:�߾��ȼӷ�
* @Param a:���飬����ΪMAXSIZE+1��a[0]��¼������ĳ���
* @Param b:���飬����ΪMAXSIZE+1��b[0]��¼������ĳ���
* @Return ans:���飬����ΪMAXSIZE+2��ans[0]��¼������ĳ���
*/
int *high_precision_add(int *a,int *b)
{
    int max_len = a[0] > b[0] ? a[0] : b[0];
    /* ��Ҫ��ans[0]���泤�ȣ��ҿ��ܴ��ڸ�λ��λ�����Ҫ������2��int�Ŀռ� */
    int *ans = (int *)malloc(sizeof(int) * (max_len + 2));
    if (ans == NULL)
    {
        printf("�ڴ����ʧ�ܣ�\n");
        return NULL;
    }
    memset(ans,0,sizeof(int) * (max_len + 2));

    /* Ϊ�˲��ƻ�ԭ�������ݣ�������ת�Ƶ�ans�������� */
    for (int i = 0; i<= a[0]; i++)
    {
        ans[i] = a[i];
    }

    for (int i = 1;i <= max_len ; i++)
    {
        ans[i + 1] += (ans[i] + b[i]) / 10;
        ans[i] = (ans[i] + b[i]) % 10;
    }

    if (ans[max_len + 1] > 0)
    {
        ans[0] = max_len + 1;
    }
    else
    {
        ans[0] = max_len;
    }
    return ans;
}

