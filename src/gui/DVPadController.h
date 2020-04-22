/**
 * This class implements the DPAD mode for the GamePad, allowing you to use the DPAD to move a virtual
 * on screen pointer, rather than using the touch screen. The program will not be able to detect
 * any DPAD/A button presses in this mode, as it may interfere with the user who is navigating the pointer.
 *
 * Created by CreeperMario in July 2017 modified by GaryOderNichts in April 2020.
 */

#ifndef DPAD_CONTROLLER_H_
#define DPAD_CONTROLLER_H_

#include <vpad/input.h>
#include "GuiController.h"
#include "DPadControllerBase.h"

class DVPadController : public DPadControllerBase
{
public:
    
    //!Constructor
    DVPadController(int channel) : DPadControllerBase(channel)
    {
        memset(&vpad, 0, sizeof(VPADStatus));
        memset(&data, 0, sizeof(PadData));
        memset(&lastData, 0, sizeof(PadData));
        
        data.validPointer = false;
    }
    
    //!Destructor
    virtual ~DVPadController() {}

    virtual bool update(int width, int height) override
    {
        DPadControllerBase::update(width, height);
        lastData = data;
        
        VPADReadError vpadError = VPAD_READ_SUCCESS;
        VPADRead(0, &vpad, 1, &vpadError);
        
        if(vpadError == VPAD_READ_SUCCESS)
        {
            data.x += vpad.lstick.x * 20;
            data.y += vpad.lstick.y * 20;

            if (data.x < -(width / 2)) data.x = -(width / 2);
            if (data.x > (width / 2)) data.x = (width / 2);
            if (data.y > (height / 2)) data.y = (height / 2);
            if (data.y < -(height / 2)) data.y = -(height / 2);
            
            data.buttons_r = vpad.btns_r;
            data.buttons_h = vpad.btns_h;
            data.buttons_d = vpad.btns_d;

            if (checkValidPointer())
            {
                data.buttons_r &= ~VPAD_BUTTON_A;
                data.buttons_h &= ~VPAD_BUTTON_A;
                data.buttons_d &= ~VPAD_BUTTON_A;
            }

            if(vpad.btns_h & VPAD_BUTTON_A)
                data.touched = true;
            else
                data.touched = false;

            return true;
        }
        
        return false;
    }
    
private:
    VPADStatus vpad;
};

#endif
