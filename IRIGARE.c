#include <mega164.h>


#define T       0x10  // terminator CLS
#define NR1     6     // numar stari CLS umiditate
#define NR2     8     // numar stari CLS temp+luminã

char err;        // cod erori (bitii 0..2)
char umd;        // nivelul de umiditate
char templ;       // nivelul de temperatura + lumina
char S;          // starea PS
char Q;          // starea CLS curenta
char in;         // PIND snapshot
char out;        // PORTB output
int timp = 0;

// --- tabela CLC
char TAB[] = {
    0xF,0x06,0x05,0x00,
    0x03,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00
};

// --- tabele CLS umiditate ---
char *TABA1[NR1];
char A0[] = {0x00,1, T,0};
char A1[] = {0x80,2, T,1};
char A2[] = {0x00,3, T,2};
char A3[] = {0x80,4, T,3};
char A4[] = {0x00,5, T,4};
char A5[] = {0x80,0, T,5};
char Tout1[] = { 0x02,0x01,0x01,0x00,0x00,0x02};

// --- tabele CLS temp+luminã ---
char *TABA2[NR2];
char B0[] = {0x00,1, T,0};
char B1[] = {0x80,2, T,1};
char B2[] = {0x00,3, T,2};
char B3[] = {0x80,4, T,3};
char B4[] = {0x00,5, T,4};
char B5[] = {0x80,6, T,5};
char B6[] = {0x00,7, T,6};
char B7[] = {0x80,0, T,7};
char Tout2[NR2] = { 0x02,0x01,0x01,0x00,0x00,0x03,0x03,0x02 };

void test_RST(void) {
    if ((in & 0x40) == 0)  //testam resetul RST
    { 
        out = out & 0x00;        // aprinde toate LED-urile
        S = 11;
    }
}

void clc(void) 
{
    char senzor = in & 0x0F;
    err = TAB[senzor];  //EROARE BITII 0,1,2        
    if (err != 0x07) S = 10; // stare eroare
        else 
        {
            out=(out | 0xFF) & 0X7F;//irigarea activa
            S = 8;
        }
}

void cls1(void) {
    char i;
    char *adr;
    char ready;   
    adr = TABA1[Q]; 
     i=0;
     ready=0;
    while (!ready) 
    {
        if ((in & 0x80) == *(adr+i)) { Q =*(adr+i+1); ready=1; }
            else if (*(adr+i) == T) ready=1;
                else i += 2;
    }
}

void cls2(void) {
    char i;
    char *adr;
    char ready;   
    adr = TABA2[Q]; 
     i=0;
     ready=0;
    while (!ready) {
        if ((in & 0x80) == *(adr+i)) { Q =*(adr+i+1); ready=1; }
            else if (*(adr+i) == T) ready=1;
                else i += 2;
    }
}

// ISR PS + CLC + CLS
interrupt [TIM0_OVF] void timer0_ovf_isr(void) 
{
    TCNT0 = 0x3C;//reinitializam timperul la 0
    
    in = PIND;
    
    switch (S) {
        case 0:
            if ((in & 0x80) == 0) S = 1;//testez SET/
                else
                    {
                        out = (out | 0xFF) & 0x7F;  //stingem ledul ce indica daca irigarea este pornita sau oprita
                        clc();
                    }
            test_RST();//testam daca s a apasat RST/
            break; 
            
        case 1:
            if ((in & 0x80) != 0) S = 2; //testam SET
            test_RST();
            break; 
            
        case 2: 
            out = (out & 0x00) | 0x87; // LED6-3 pornite 
            if ((in & 0x20) == 0) S = 3;  //testam UMD/
            if ((in & 0x10) == 0) S = 4;  //TESTAM TEMPL/
            if ((in & 0x40) == 0) S = 7;  //testam /RST
            test_RST();
            break;
            
        case 3:
            if ((in & 0x20) != 0) S = 5;
            test_RST();
            break;  
            
        case 4:
            if ((in & 0x10) != 0) S = 6;
            test_RST();
            break;
            
        case 5:
            cls1();
            umd = Tout1[Q] << 5;//iesire cls bitii 5,6
            out = out & 0x9F;//stergem bitii 5, 6 - masca 10011111
            out = out | umd;//actualizez out
            if ((in & 0x40) == 0) S = 7; //testam /RST 
            test_RST();
            break; 
                    
        case 6:
            cls2();
            templ = Tout2[Q] << 3;//iesire cls bitii 4,3
            out = out & 0xE7;//stergem bitii 4, 3 - masca 11100111
            out = out | templ;//actualizez out
            if ((in & 0x40) == 0) S = 7; //testam /RST  
            test_RST();
            break; 
        
        case 7: 
            if ((in & 0x40) != 0) S = 0;//testez RST
            test_RST();
            break;
            
        case 8:
            if ((in & 0x80) == 0) S = 1; //testam SET/
            timp = (timp+1) % 10; //ca sa contorizam 5 minute trebuie sa punem      dar pentru testare am pus 10 ca sa mearga mai rapid
            if ((in & 0xF) != 0)   //testez senzorii
             {   
                out = (out | 0xFF) & 0x7F;
                S = 9;
             }  
             else if(timp == 0)
             {        
                out = (out | 0xFF) & 0x7F;
                S = 9;
             }
            test_RST();
            break; 
            
        case 9:
            out = (out | 0xFF) & 0xFF;
            S = 0;
            timp = 0;  
            test_RST();
            break;    
        
        case 10:
            out = out & 0xFF; // inchid toate becurile
            out = (out | err) << 0; // actualizeaza out
            out = out | 0xF8; //inchid toate LED-urile in afara de cele de eroare LED 2-0
            test_RST();// testeaza RST/ 
            break;
             
         case 11: 
            if ( (in & 0x40) != 0 ) // testeaza RST
                {
                    out = out | 0xFF; // stinge LED7-0 
                    err=0x07; 
                    out = out | err; // sterge erori 
                    S=0;
                } 
            test_RST();// testeaza RST/ 
            break;
            }

            PORTB = out; //iesirea

} 
                  
            
         

void main(void) {
    TABA1[0] = A0; TABA1[1] = A1; TABA1[2] = A2;TABA1[3] = A3; TABA1[4] = A4; TABA1[5] = A5;
    TABA2[0] = B0; TABA2[1] = B1; TABA2[2] = B2; TABA2[3] = B3;TABA2[4] = B4; TABA2[5] = B5; TABA2[6] = B6; TABA2[7] = B7;
    out = 0xFF;
    S = 0;
    Q = 0;
    //while (1) { }- ca sa nu mai avem brakepoint in debugger
}

