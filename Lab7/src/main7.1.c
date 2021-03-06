#include "stm32l476xx.h"
extern void GPIO_init();
extern void delay_1s();

int user_press_button (void);
void SystemClock_Config (void);
void set_HCLK (int MHz);


int main(){
	int freq[] = {1, 6, 10, 16, 40};
	int i = 0;
	SystemClock_Config();
	GPIO_init();
	while(1){
		if (user_press_button())
		{
			//TODO: Update system clock rate
			i = (i + 1) % 5;
			set_HCLK (freq[i]);
		}
		GPIOA->BSRR = (1<<5);
		delay_1s();
		GPIOA->BRR = (1<<5);
		delay_1s();
	}
}

void SystemClock_Config (void)
{
	//TODO: Change the SYSCLK source and set the corresponding Prescaler value.
	set_HCLK (1);
}

int user_press_button (void)
{
	int	deb = 0;
	while (!(GPIOC->IDR & (0x1 << 13)) && deb++ < 1000);
	return !(GPIOC->IDR & (0x1 << 13));
}

void set_HCLK (int MHz)
{
	/* switch the SYSCLK to MSI */
	RCC->CFGR &= ~RCC_CFGR_SW_Msk;
	RCC->CFGR |= RCC_CFGR_SW_MSI;
	while ((RCC->CFGR & RCC_CFGR_SWS_Msk) != RCC_CFGR_SWS_MSI);
	/* turn the PLL off */
	RCC->CR &= ~RCC_CR_PLLON;
	while (RCC->CR & RCC_CR_PLLRDY);
	/* set the RCC_PLLCFGR */
	switch (MHz) {
	case 1:
	case 16:
		RCC->PLLCFGR = 0x03000c22;
		break;
	case 10:
	case 40:
		RCC->PLLCFGR = 0x03000a02;
		break;
	case 6:
		RCC->PLLCFGR = 0x03000c02;
		break;
	}
	/* turn the HSI16 on */
	RCC->CR |= RCC_CR_HSION;
	while ((RCC->CR & RCC_CR_HSIRDY) == 0);
	/* turn the PLL on */
	RCC->CR |= RCC_CR_PLLON;
	while ((RCC->CR & RCC_CR_PLLRDY) == 0);
	/* switch the SYSCLK to PLL */
	RCC->CFGR &= ~RCC_CFGR_SW_Msk;
	RCC->CFGR |= RCC_CFGR_SW_PLL;
	while ((RCC->CFGR & RCC_CFGR_SWS_Msk) != RCC_CFGR_SWS_PLL);
	/* set the HPRE */
	RCC->CFGR &= ~RCC_CFGR_HPRE_Msk;
	switch (MHz) {
	case 1:
		RCC->CFGR |= RCC_CFGR_HPRE_DIV16;
		break;
	case 6:
		RCC->CFGR |= RCC_CFGR_HPRE_DIV8;
		break;
	case 10:
		RCC->CFGR |= RCC_CFGR_HPRE_DIV4;
		break;
	case 16:
	case 40:
		RCC->CFGR |= RCC_CFGR_HPRE_DIV1;
		break;
	}
}
