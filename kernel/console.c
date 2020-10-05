#include "include/console.h"
#include "include/spinlock.h"
#include "include/types.h"
#include "include/uart.h"

void consoleinit()
{
  uartinit();
}

#define BACKSPACE 0x100

void consputc(int c)
{
  if(c == BACKSPACE){
    // if the user typed backspace, overwrite with a space.
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
  } else {
    uartputc_sync(c);
  }
}
