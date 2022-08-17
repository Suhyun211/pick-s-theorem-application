import math

def toFrag(num):
    numstring=str(num)
    numbunja=int(numstring.replace('.', ''))
    numbunmo=10**(len(numstring)-2)
    return Frac(numbunja, numbunmo)


class Frac:
    #Frac(a,b): a: 분자, b: 분모
    def __init__(self, a, b):
        #분자(a)
        self.__a=a
        #분모(b)
        self.__b=b

    def Abbreviate(self):
        gcd=math.gcd(self.__a, self.__b)
        self.__a/=gcd
        self.__b/=gcd

    def bunmo(self):
        return self.__b
    def bunja(self):
        return self.__a

