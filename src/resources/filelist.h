#include "../gctypes.h"
/****************************************************************************
 * Loadiine resource files.
 * This file is generated automatically.
 * Includes 16 files.
 *
 * NOTE:
 * Any manual modification of this file will be overwriten by the generation.
 ****************************************************************************/
#ifndef _FILELIST_H_
#define _FILELIST_H_

#include "bgMusic_ogg.h"
#include "button_click_mp3.h"
#include "button_png.h"
#include "buttonSelected_png.h"
#include "font_ttf.h"
#include "homebrewButton_png.h"
#include "homebrewButtonSelected_png.h"
#include "launchMenuBox_png.h"
#include "leftArrow_png.h"
#include "player0_point_png.h"
#include "player1_point_png.h"
#include "player2_point_png.h"
#include "player3_point_png.h"
#include "player4_point_png.h"
#include "progressWindow_png.h"
#include "rightArrow_png.h"

typedef struct _RecourceFile
{
	const char          *filename;
	const unsigned char *DefaultFile;
	const unsigned int  &DefaultFileSize;
	unsigned char	    *CustomFile;
	unsigned int        CustomFileSize;
} RecourceFile;

static RecourceFile RecourceList[] =
{
	{"bgMusic.ogg", bgMusic_ogg, bgMusic_ogg_size, NULL, 0},
	{"button_click.mp3", button_click_mp3, button_click_mp3_size, NULL, 0},
	{"button.png", button_png, button_png_size, NULL, 0},
	{"buttonSelected.png", buttonSelected_png, buttonSelected_png_size, NULL, 0},
	{"font.ttf", font_ttf, font_ttf_size, NULL, 0},
	{"homebrewButton.png", homebrewButton_png, homebrewButton_png_size, NULL, 0},
	{"homebrewButtonSelected.png", homebrewButtonSelected_png, homebrewButtonSelected_png_size, NULL, 0},
	{"launchMenuBox.png", launchMenuBox_png, launchMenuBox_png_size, NULL, 0},
	{"leftArrow.png", leftArrow_png, leftArrow_png_size, NULL, 0},
	{"player0_point.png", player0_point_png, player0_point_png_size, NULL, 0},
	{"player1_point.png", player1_point_png, player1_point_png_size, NULL, 0},
	{"player2_point.png", player2_point_png, player2_point_png_size, NULL, 0},
	{"player3_point.png", player3_point_png, player3_point_png_size, NULL, 0},
	{"player4_point.png", player4_point_png, player4_point_png_size, NULL, 0},
	{"progressWindow.png", progressWindow_png, progressWindow_png_size, NULL, 0},
	{"rightArrow.png", rightArrow_png, rightArrow_png_size, NULL, 0},
	{NULL, NULL, 0, NULL, 0}
};

#endif
