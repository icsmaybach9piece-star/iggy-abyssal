#include <gba_systemcalls.h>
#include <gba_video.h>
#include <gba_input.h>
#include <gba_sprites.h>

int main(void)
{
    irqInit();
    irqEnable(IRQ_VBLANK);

    SetMode(MODE_3 | BG2_ON);

    while (1)
    {
        VBlankIntrWait();
        scanKeys();

        /*
         * IGGY ABYSSAL
         * Prototype foundation.
         *
         * The actual player, world, enemies and boss
         * will be added here as we build the game.
         */
    }

    return 0;
}
