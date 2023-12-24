float average(float arr[], int len)
{
    float res = 0;
    for (int i = 0; i < len; i++)
    {
        res += arr[i];
    }
    return res / len;
}