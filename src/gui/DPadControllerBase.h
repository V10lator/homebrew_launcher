#ifndef DPAD_CONTROLLER_BASE_H_
#define DPAD_CONTROLLER_BASE_H_

#include <gui/GuiController.h>
#include "dynamic_libs/vpad_functions.h"

#define POINTER_TIMEOUT 250

class DPadControllerBase : public GuiController
{
public:
    
    //!Constructor
    DPadControllerBase(int channel) : GuiController(channel)
    {
        data.validPointer = false;
        updates = 0;
    }
    
    //!Destructor
    virtual ~DPadControllerBase() {}
    
    void invalidatePointer()
    {
        updates = POINTER_TIMEOUT;
    }

    virtual bool update(int width, int height) override
    {
        updates++;
        return true;
    }

    bool checkValidPointer()
    {
        if ((lastData.x == data.x && lastData.y == data.y))
        {
            if (updates >= POINTER_TIMEOUT)
            {
                // we did not move in time or our pointer is invalid
                data.validPointer = false;
                // do not overflow counter
                updates = POINTER_TIMEOUT + 1;
            }
        }
        else
        {
            // we moved so the pointer is valid
            data.validPointer = true;

            // reset counter
            updates = 0;

            return true;
        }

        return false;
    }

protected:
    uint64_t updates;
};

#endif
