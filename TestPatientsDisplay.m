classdef TestPatientsDisplay < matlab.uitest.TestCase
    properties
        App
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.App = PatientsDisplay;
            testCase.addTeardown(@delete,testCase.App);
        end
    end
    
    methods (Test)        
        function test_bloodPressure(testCase)
            % Extract blood pressure data from app
            t = testCase.App.DataTab.Children.Data;
            t.Gender = categorical(t.Gender);
            allMales = t(t.Gender == 'Male',:);
            maleDiastolicData = allMales.Diastolic';
            maleSystolicData = allMales.Systolic';
            
            % Verify ylabel and that male Systolic data shows
            ax = testCase.App.UIAxes;
            testCase.verifyEqual(ax.YLabel.String,'Systolic')
            testCase.verifyEqual(ax.Children.YData,maleSystolicData)
            
            % Switch to 'Diastolic' reading
            testCase.choose(testCase.App.BloodPressureSwitch,'Diastolic')
            
            % Verify ylabel changed and male Diastolic data shows
            testCase.verifyEqual(ax.YLabel.String,'Diastolic')
            testCase.verifyEqual(ax.Children.YData,maleDiastolicData);
        end

        function test_plottingOptions(testCase)
            % Press the histogram radio button
            testCase.press(testCase.App.HistogramButton)
            
            % Verify xlabel updated from 'Weight' to 'Systolic'
            testCase.verifyEqual(testCase.App.UIAxes.XLabel.String,'Systolic')
            
            % Change the Bin Width to 9
            testCase.choose(testCase.App.BinWidthSlider,9)
            
            % Verify the number of bins is now 4
            testCase.verifyEqual(testCase.App.UIAxes.Children.NumBins,4)
        end
        
        function test_tab(testCase)     
            % Choose Data Tab
            dataTab = testCase.App.DataTab;
            testCase.choose(dataTab)
            
            % Verify Data Tab is selected
            testCase.verifyEqual(testCase.App.TabGroup.SelectedTab.Title,'Data')
        end
        
    end
end
