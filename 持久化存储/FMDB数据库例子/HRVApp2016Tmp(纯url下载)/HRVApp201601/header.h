
#include "ParameterDefine.h"
#include "PreDealFunc.h"


#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <stdio.h>
#include <stdlib.h>
#include "math.h"
#include <string>
#include <sstream>
#include <iostream>
#include <cstdio>
#include <fstream>
#include <cstdlib>
#include <cmath>

using namespace std;


typedef struct TmDoR
{
	float meanNN;
	float SDNN;
	float rMSSD;
	float PNN50;
}TimeDomainResult;
typedef struct FreqDoR
{
	float TP;
	float VLFP;
	float LFP;
	float HFP;
	float NLFP;
	float NHFP;
	float LFHF;
}FreqDomainResult;
typedef struct strsR
{
	float ANSBalance;      //����-��������ƽ���
	unsigned PsyStress;      //����ѹ��
	unsigned PhiStress;	  //����ѹ��
	unsigned StressIndex;    //�ۺ�ѹ��ָ��
	unsigned AntiStress;	  //��ѹ����
	unsigned HeartFunAge;	  //���๦������ 1�������꣬2����׳�꣬3�����꣬4���������ˣ�5������
	unsigned Fatigue;	      //ƣ��ָ��
	unsigned Motion;         //����
}StressAssess;
unsigned int readRRtxt(char *filepath,float **x,float **y,unsigned int *nmax);
short StressEstimate(float *y, float *x, unsigned int ndata, unsigned int gender, StressAssess *stressAssess);
short RRfilter(float *RRy, float *RRx, unsigned int ndata, float *filty, float *filtx, unsigned int &lenNN);
void MoveMean(float *data, unsigned int start, float &sumNum, unsigned int movwin, float &aver, float &SD, short &flag);
void meanfun(float *data, unsigned int len, float *aver, float *SD, unsigned int varflag);
extern void exit();
void errors(char *s);
unsigned TimeDomainIndex(float *y, unsigned int lenNN, TimeDomainResult *TimeResult);
unsigned FreqDomainIndex(float *freq, float *psdx, unsigned int psdLen, FreqDomainResult *FreqResult);
unsigned CalStressScore(TimeDomainResult *TimeResult, FreqDomainResult *FreqResult, StressAssess *stressAssess, unsigned int gender);
