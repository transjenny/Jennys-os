void WriteTOScreen(char CharToWrite, int pointindisplay);
void PAUSE();
void Wait();
void LoadFileByTag(short int FileTAG, short int* LoadArea);


void KernelEntry()
{
    LoadFileByTag(0x7f, (short int*)0x9fff);
    WriteTOScreen('H', 0);
    WriteTOScreen('H', 0);
    PAUSE();
    

}


void LoadFileByTag(short int FileTAG, short int* LoadArea)
{
    short int* filesystem = ( short int*) 0x1c00; // cant use past 16 bit ints
    while(1==1) // true has not been def with no c libs
    {
        filesystem++;
        if (*filesystem == 0xbb) // find the end of the file headers
        {
            break;
        }
    }
    filesystem++;
    while(1==1){
        filesystem++;
        if(*filesystem == 0x7f)
        {
            break;
        }

        
    }
    return;
}

void WriteTOScreen(char CharToWrite, int pointindisplay)
{
    asm("mov %0, %%al"
    :
    : "r" (CharToWrite)
    : "%al"
    );
    asm("mov $0xb800, %bx"); // move memory address into bx
    asm("mov %bx, %es");
    asm("movb %%al, %%es:(%0)"
    :
    : "r" (pointindisplay)
    : "%al"
    );
    return;
}

void PAUSE()
{
    asm("hlt");
    PAUSE();
}

void Wait(int timer) // wait till the cpu is done loading the screed(the kernel loads too quickly lol)
{
    while(timer < 500){
        timer++;
    }
    return;

}


