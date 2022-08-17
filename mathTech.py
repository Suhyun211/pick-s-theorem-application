from math import *

def gcdarr(arr):
    GCDarr = arr[0] #arr 리스트의 첫 번째 항목(0번 방)을 GCDarr에 저장
    for i in range(len(arr)): # i가 0부터 리스트 arr의 길이만큼 반복
        GCDarr = gcd(GCDarr, arr[i]) # GCDarr에 GCDarr과 arr[i]의 최대공약수를 저장
    return GCDarr #반환되는 GCDarr이 리스트 arr의 최대공약수!

def lcmarr(arr):
    GCDarr=gcdarr(arr)
    LCMarr = arr[0] #arr 리스트의 첫 번째 항목(0번 방)을 LCMarr에 저장
    for i in range(len(arr)): #i가 0부터 리스트 arr의 길이만큼 반복
        LCMarr = LCMarr * arr[i] // GCDarr #LCMarr에 LCMarr과 arr[i]의 최소공배수를 저장
    return LCMarr

