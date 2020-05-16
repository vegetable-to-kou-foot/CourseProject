/************************************
 Author:        17010150014 胡广鹏
 Date:          2020/5/16
 Description:   该程序实现高精度加减法
*************************************/

/* sscanf_s使用前需要定义，参见 https://zh.cppreference.com/w/c/io/fscanf */
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
    printf("高精度计算工具\nAuthor：17010150014 胡广鹏\n退出程序请按ctrl+Z+2次enter。\n");
    printf("请输入x +/- y，按enter开始计算，表达式前后不应有空格：\n");
    while(1)
    {
        printf("\n---------------------------------------------\n");
        int in = scanf("%[^\n]",input_string);
        /* 清除缓冲区，C Primer上推荐的写法不符合华为的C语言编程规范，因此将其按规范改写 */
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
            printf("输入格式有误，读取失败\n");
            continue;
        }


        /* 检查用户输入是否是允许的字符 */
        int input_str_len = strlen(input_string);
        int toNext = 0;
        for (int i = 0; i < input_str_len; i++)
        {
            if (!((input_string[i] >= '0' && input_string[i] <= '9') ||
                input_string[i] == '+' || input_string[i] == '-' || input_string[i] == ' '))
            {
                printf("存在非法字符\n");
                toNext = 1;
                break;
            }
        }
        if (toNext)
        {
            continue;
        }

        /* 解析操作数与运算符，此处兼任检测用户输入是否有缺失的部分。若开头结尾存在空格，也会解析失败。 */
        memset(input_string_1,0,MAXSIZE);
        memset(input_string_2,0,100);
        memset(input_string_3,0,MAXSIZE);
        /* 根据华为C编程规范，使用安全的输入函数。 */
        /* 关于如何判断能否使用sscanf_s，参见 https://zh.cppreference.com/w/c/io/fscanf */
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
            printf("表达式缺少成分；或输入格式有误，表达式前后不应有空格\n");
            continue;
        }


        int input_int_1[MAXSIZE+1],input_int_2[MAXSIZE+1];

        /* 此处清零是必要的，否则减法运算中上一次计算结果将影响下一次运算。 */
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

        /* 修正字符串长度，减小到1时不再继续减小。 */
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
            printf("没有检测到操作符\n");
            continue;
        }

        if (ans == NULL)
        {
            printf("计算出错，请重新输入\n");
            continue;
        }

        /* 若ans[0]为负，说明结果为负，此处需要解析出结果的正负并显示出来。 */
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

        /* 不能忘了释放内存，释放之后要防止野指针 */
        free(ans);
        ans = NULL;
        printf("%s\n",output_string);
    }
    return 0;
}


/**
*@ Descrption:高精度比较
* @Param a:数组，长度为MAXSIZE+1，a[0]记录了数组的长度
* @Param b:数组，长度为MAXSIZE+1，b[0]记录了数组的长度
* @Return 1:a<b ; 0:a==b ; -1:a>b
*/
int high_precision_compare(int *a,int *b)
{
    /* 先比长度 */
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
        /* 长度一致再从高位到低位比较 */
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
        /* 完全一致则输出0 */
        return 0;
    }
}


/**
*@ Descrption:高精度减法
* @Param a:数组，长度为MAXSIZE+1，a[0]记录了数组的长度
* @Param b:数组，长度为MAXSIZE+1，b[0]记录了数组的长度
* @Return ans:数组，长度为MAXSIZE+1，ans[0]记录了数组的长度
*/
int *high_precision_sub(int *a,int *b)
{
    int max_len = a[0] > b[0] ? a[0] : b[0];
    /* 需要在ans[0]保存长度，因此要多申请1个int的空间 */
    int *ans = (int *)malloc(sizeof(int) * (max_len + 1));
    if (ans == NULL)
    {
        printf("内存分配失败！\n");
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
            /* 不够减要借位 */
            if (ans[i] < b[i])
            {
                ans[i+1]--;
                ans[i] += 10;
            }
            ans[i] = ans[i] - b[i];
        }
        /* 修正位数 */
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
*@ Descrption:高精度加法
* @Param a:数组，长度为MAXSIZE+1，a[0]记录了数组的长度
* @Param b:数组，长度为MAXSIZE+1，b[0]记录了数组的长度
* @Return ans:数组，长度为MAXSIZE+2，ans[0]记录了数组的长度
*/
int *high_precision_add(int *a,int *b)
{
    int max_len = a[0] > b[0] ? a[0] : b[0];
    /* 需要在ans[0]保存长度，且可能存在高位进位，因此要多申请2个int的空间 */
    int *ans = (int *)malloc(sizeof(int) * (max_len + 2));
    if (ans == NULL)
    {
        printf("内存分配失败！\n");
        return NULL;
    }
    memset(ans,0,sizeof(int) * (max_len + 2));

    /* 为了不破坏原来的数据，将内容转移到ans中做计算 */
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

