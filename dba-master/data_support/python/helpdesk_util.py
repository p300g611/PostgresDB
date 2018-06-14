#!/usr/bin/python
#Author : Rohit Yadav

import lcsbreaklink
import script1_edit_organization
import user_management2
import update_gradelevel
import sys

def main():

    try:

        inputitem = raw_input('Enter 1 to delete lcsentries,2 to edit organization,3 to activate/deactivate user,4 to change grade level:')

        if (inputitem == '1'):
            lcsbreaklink.main()
        elif (inputitem == '2'):
            script1_edit_organization.main()
        elif (inputitem == '3'):
            user_management2.main()
        elif (inputitem == '4'):
            update_gradelevel.main()
        elif (inputitem == 'exit' or inputitem == 'Exit' or inputitem == ''):
            exit()

    except Exception, e:
        print repr(e)
        print ("***ERROR***:Please contact Datasupport Team with error message") , sys.exc_info()[0]


if __name__ == "__main__":
    main()
