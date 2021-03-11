# Examination Security: Facial Detection

Edited From: RAHUL RANJAN, Avi Nehemiah, MATHWORKS & MATLAB Applications

Authors: Timothy F. (CSC 6630/tfisher10), Kevin S.(CSC 4630/kseveur1), Micheal M.
(CSC 4630/ mmoloney1), Adrian M.(CSC 4630/amcghee3)

Description: To develop a GUI that recgonizes a face and matches it to the
images GUI's database. The database will automatically check if the
matched faced from the live captured image is present in the database.
 
## Assumptions: 
- User knows basic usage of a computers components (mouse, keyboard,
webcam, etc.)
- Must download the complete zip file and not edit the orgnization of the folders. 
- User has MATLAB2018a with Computer Vision toolbox, Image Acquistion
toolbox,  Statitics and Machine Learning Toolbox and the 
correct video adapter for MATLAB installed. 

## Usage:
1.) In MATLAB Command Window, type TestVerification to begin the program. 
2.) First select the student's name you are trying to verify. This will begin the training and set the matching to the student's folder. ( Go to step 5 if student name is not in drop down box.)
3.) Click the Verify ID then click Camera. Follow all the prompts in the message boxes and dialoge boxes.
4.  If matched, then in the right window you will have a matched image from the database. If not matched then you will have a red x. 
5.) If student is not in the database then go to Database menu option. Then click New Student to add a new folder to FaceDatabaseFolder. 
6.) Then add new student image by scrolling to Database then clicking New Student Picture to add a new student picture. Follow all the prompts.  
7.) Reset the prgram after you added the new pictures. 
8.) Redo steps 1 through 4. 
9.) Quit the program when you are done.  

## Program Outline & Responsiblities (R)

TestVerification.m
1. R - Timothy F. / Adrian M. GUI Initialization code (lines 31 to 48)
    - function TestVerification_OpeningFcn(hObject, eventdata, handles, varargin)
    - function varargout = TestVerification_OutputFcn(hObject, eventdata, handles)
    
2. R - Micheal M. 
    - function Verify_Callback(hObject, eventdata, handles) 
    - function Camera_Callback(hObject, eventdata, handles)

3. R - Adrian M. / Timothy F. (RAHUL)
    - function Database_Callback(hObject, eventdata, handles)
    - function View_Callback(hObject, eventdata, handles)
    - function Picture_Callback(hObject, eventdata, handles)
    - function New_Student_Callback(hObject, eventdata, handles)

4. R - Timothy F. 
    - function Other_Callback(hObject, eventdata, handles)
    - function HE_LP_Callback(hObject, eventdata, handles)
    - function Reset_Callback(hObject, eventdata, handles)
    - function All_Callback(hObject, eventdata, handles)
    - function Exit_Callback(hObject, eventdata, handles)
    - function Quit_Callback(hObject, eventdata, handles)

5. R - Micheal M. 
    - function Student_Select_Callback(hObject, eventdata, handles)
    - function Student_Select_CreateFcn(hObject, eventdata, handles)


6. train_match.m (AVI)
    1. R - Micheal M. / Kevin S.
        classdef train_match
            properties
            methods
                function setStudentChoice
                function train
                function match

## Other Responsiblities:
    Troubleshooting / Debugging: All
    Ideas : All
    Video Editing: Micheal M. 

## Notes: 
- If you have a windows or linux system then use need to change the .m files code
  to your respective adaptors.
- Change the / to \ when using windows!!!!
- Must install all the toolboxs/adaptors for this to fully function. 
- Keep the folder/file names consistent and keep the same structure as downloaded orginally.  

