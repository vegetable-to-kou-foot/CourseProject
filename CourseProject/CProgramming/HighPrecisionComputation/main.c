#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXSIZE 10000

int high_precision_compare(int *a,int *b)
{
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
        return 0;
    }
}

int *high_precision_sub(int *a,int *b)
{
    int max_len = a[0] > b[0] ? a[0] : b[0];
    //��Ҫ��ans[0]���泤�ȣ����Ҫ������1��int�Ŀռ�
    int *ans = (int *)malloc(sizeof(int) * (max_len + 1));
    if (ans == NULL)
    {
        printf("�ڴ����ʧ�ܣ�\n");
        return NULL;
    }
    memset(ans,0,sizeof(int) * (max_len + 1));

    int cmp = high_precision_compare(a,b);
    /*for (int i=0;i<=a[0];i++)printf("%d ",a[i]);
    printf("\n");
    for (int i=0;i<=b[0];i++)printf("%d ",b[i]);
    printf("\n");
    printf("cmp = %d\n",cmp);*/
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
            if (ans[i] < b[i])
            {
                ans[i+1]--;
                ans[i] += 10;
            }
            ans[i] = ans[i] - b[i];
        }
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
}

int *high_precision_add(int *a,int *b)
{
    int max_len = a[0] > b[0] ? a[0] : b[0];
    //��Ҫ��ans[0]���泤�ȣ��ҿ��ܴ��ڸ�λ��λ�����Ҫ������2��int�Ŀռ�
    int *ans = (int *)malloc(sizeof(int) * (max_len + 2));
    if (ans == NULL)
    {
        printf("�ڴ����ʧ�ܣ�\n");
        return NULL;
    }
    memset(ans,0,sizeof(int) * (max_len + 2));

    for (int i = 1;i <= max_len ; i++)
    {
        int sum_tmp = ans[i] + a[i] + b[i];
        ans[i] = sum_tmp % 10;
        ans[i + 1] = sum_tmp / 10;
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

int main()
{

    char input_string[2 * MAXSIZE + 1],input_string_1[MAXSIZE],input_string_2[5],input_string_3[MAXSIZE];
    printf("�߾��ȼ��㹤��\nAuthor��17010150014 ������\n�˳������밴ctrl+Z+enter��\n");
    printf("������x +/- y����enter��ʼ���㣬���ʽǰ��Ӧ�пո�\n");
    while(scanf("%[0-9 +-]",input_string) != EOF)
    {
        setbuf(stdin,NULL);
        //printf("%s\n",input_string);
        int input_str_len = strlen(input_string);
        if (input_string[0] < '0' || input_string[0] > '9' ||
            input_string[input_str_len - 1] < '0' || input_string[input_str_len - 1] > '9')
        {
            printf("�����ʽ���󣬱��ʽǰ��Ӧ�пո�\n");
            continue;
        }
        sscanf(input_string,"%[0-9]%*[+- ]%*[0-9]",input_string_1);
        sscanf(input_string,"%*[0-9 ]%[+-]%*[0-9]",input_string_2);
        sscanf(input_string,"%*[0-9]%*[ +-]%[0-9]",input_string_3);
        //printf("%s  %s  %s\n",input_string_1,input_string_2,input_string_3);

        int input_int_1[MAXSIZE+1],input_int_2[MAXSIZE+1];
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
        free(ans);
        ans = NULL;
        printf("%s\n",output_string);
    }
    return 0;
}
