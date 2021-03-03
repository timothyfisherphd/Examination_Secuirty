%{

Description:

This class manages the student image just taken to images of students
currently in the database using Support vector Machines (SVM) machine
learning algorithm.

%}

classdef train_match < handle
    
    properties
        faceDatabase = imageSet('FaceDatabaseFolder', 'recursive');
        training;
        test;
        trainingFeatures;
        featureCount = 1;
        faceClassifier;
        personIndex;
        StudentChoice;
    end
    
    methods
        
        % Function allows the user to set the student to be matched.
        function setStudentChoice(obj,student)    
            obj.StudentChoice=student;
            done = msgbox('Student Loaded','Complete','modal');
            pause(2)
            delete(done)
        end
        
        % Function trains the classifier by extracting Histograms of
        % Oriented Gradients (HOG) features and pushing that data through a
        % classifiction model (SVM)
        function train(obj)
            
            obj.training = obj.faceDatabase;
            [hogFeature, visualization] = extractHOGFeatures(read(obj.training(1), 1));
            hogColSize = length(hogFeature);
            obj.trainingFeatures = zeros(size(obj.training,1) * obj.training(1).Count,hogColSize);
            for i = 1:size(obj.training,2)
                for j = 1:obj.training(i).Count
                    obj.trainingFeatures(obj.featureCount, :) = extractHOGFeatures(read(obj.training(i), 1));
                    trainingLabel{obj.featureCount} = obj.training(i).Description;
                    obj.featureCount = obj.featureCount+1;
                end
                obj.personIndex{i} = obj.training(i).Description;
            end
            obj.faceClassifier = fitcecoc(obj.trainingFeatures, trainingLabel);
            msgbox('Training Complete.','Complete','modal');
        end
        
        
        % Function extracts HOG features from new passed in student image
        % compares it to the classificaion model, and outputs the predicted
        % match
        function match(obj,image)
            
            scoring = false;
            queryImage = image;
            queryFeatures = extractHOGFeatures(queryImage); % Extract histogram of oriented gradients (HOG) features
            
            % Predict labels using support vector machine (SVM) classifier
            [personLabel, score, X] = predict(obj.faceClassifier, queryFeatures);
            
            
            for k = 1:length(score)
                if (score(k) * (-100)) <= 20  %We are looking for an accuracy of <= 7%
                    scoring = true;
                end
            end
            if (scoring == false) || (strcmp(obj.StudentChoice,personLabel{1})==0)
                errorImage = imread('redX.jpeg');
                redX = imresize(errorImage,[300  300]);
                booleanIndex = strcmp(personLabel, obj.personIndex);
                integerIndex = find(booleanIndex);
                subplot(1,2,1);
                imshow(queryImage);
                title('Student Picture');
                ax = gca;
                ax.FontSize = 18;
                
                subplot(1,2,2);
                imshow(redX);
                title('No Matched Student Found');
                ax = gca;
                ax.FontSize = 18;
                return
            end
            
            % Go back to training set to find a match
            booleanIndex = strcmp(personLabel, obj.personIndex);
            integerIndex = find(booleanIndex);
            subplot(1,2,1);
            imshow(queryImage);
            title('Student Picture');
            
            subplot(1,2,2);
            imshow(read(obj.training(integerIndex), 1));
            title('Matched Student');
        end
    end
end