/*  RetroArch - A frontend for libretro.
 *  Copyright (C) 2010-2014 - Hans-Kristian Arntzen
 *  Copyright (C) 2011-2014 - Daniel De Matteis
 *
 *  RetroArch is free software: you can redistribute it and/or modify it under the terms
 *  of the GNU General Public License as published by the Free Software Found-
 *  ation, either version 3 of the License, or (at your option) any later version.
 *
 *  RetroArch is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 *  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 *  PURPOSE.  See the GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along with RetroArch.
 *  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef MENU_COMMON_H__
#define MENU_COMMON_H__

#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "../../boolean.h"
#include "../../general.h"
#include "menu_navigation.h"
#include "../info/core_info.h"
#include "file_list.h"
#include "history.h"
#include "../../input/input_common.h"
#include "../../input/keyboard_line.h"
#include "../../performance.h"

#if defined(HAVE_CG) || defined(HAVE_HLSL) || defined(HAVE_GLSL)

#ifndef HAVE_SHADER_MANAGER
#define HAVE_SHADER_MANAGER
#endif

#include "../../gfx/shader_parse.h"
#endif

#ifdef HAVE_RGUI
#define MENU_TEXTURE_FULLSCREEN false
#else
#define MENU_TEXTURE_FULLSCREEN true
#endif

#ifndef GFX_MAX_SHADERS
#define GFX_MAX_SHADERS 16
#endif

#define RGUI_SETTINGS_CORE_INFO_NONE    0xffff
#define RGUI_SETTINGS_CORE_OPTION_NONE  0xffff
#define RGUI_SETTINGS_CORE_OPTION_START 0x10000


#define RGUI_KEYBOARD_BIND_TIMEOUT_SECONDS 5

#ifdef __cplusplus
extern "C" {
#endif

typedef enum
{
   RGUI_FILE_PLAIN,
   RGUI_FILE_DIRECTORY,
   RGUI_FILE_DEVICE,
   RGUI_FILE_USE_DIRECTORY,
   RGUI_SETTINGS,
   RGUI_INFO_SCREEN,
   RGUI_START_SCREEN,
} rgui_file_type_t;

typedef enum
{
   RGUI_ACTION_UP,
   RGUI_ACTION_DOWN,
   RGUI_ACTION_LEFT,
   RGUI_ACTION_RIGHT,
   RGUI_ACTION_OK,
   RGUI_ACTION_CANCEL,
   RGUI_ACTION_REFRESH,
   RGUI_ACTION_SELECT,
   RGUI_ACTION_START,
   RGUI_ACTION_MESSAGE,
   RGUI_ACTION_SCROLL_DOWN,
   RGUI_ACTION_SCROLL_UP,
   RGUI_ACTION_MAPPING_PREVIOUS,
   RGUI_ACTION_MAPPING_NEXT,
   RGUI_ACTION_NOOP
} rgui_action_t;

void menu_poll_bind_get_rested_axes(void *data);
void menu_poll_bind_state(void *data);
bool menu_poll_find_trigger(void *data1, void *data2);
bool menu_custom_bind_keyboard_cb(void *data, unsigned code);

void *menu_init(const void *data);
bool menu_iterate(void);
void menu_free(void *data);

void menu_ticker_line(char *buf, size_t len, unsigned tick, const char *str, bool selected);

void load_menu_game_prepare(void);
void load_menu_game_prepare_dummy(void);
bool load_menu_game(void);
void load_menu_game_history(unsigned game_index);
extern void load_menu_game_new_core(void);
void menu_rom_history_push(const char *path, const char *core_path,
      const char *core_name);
void menu_rom_history_push_current(void);

bool menu_replace_config(const char *path);

bool menu_save_new_config(void);

int menu_defer_core(void *data, const char *dir, const char *path, char *deferred_path, size_t sizeof_deferred_path);

uint64_t menu_input(void);

void menu_flush_stack_type(unsigned final_type);
void menu_update_system_info(void *data, bool *load_no_rom);
void menu_build_scroll_indices(void *data);

#ifdef __cplusplus
}
#endif

#endif
