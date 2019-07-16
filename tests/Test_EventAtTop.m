% 
% CFE SIL Interface code generation test cases for:
% Model: TlmMessageSingle
% Tests:
%   - Event blocks at top model level
%   - Event block in atomic (nonvirtual subsystem)
%

classdef Test_EventAtTop < cfetargettester.CfeTargetTester
    
    properties
        TestModel = 'EventAtTop' 
        TestInterface = 'eci_interface.h'
        TestData  = 'test_data.mat'
    end
    
    methods(TestClassSetup)
        function loadModel(testcase)
                load_system(testcase.TestModel);
                testcase.configModelForTesting(testcase.TestModel);                
                testcase.addTeardown(@() close_system(testcase.TestModel, 0));
        end
    end
    
    methods(Test)
        %
        % Check that simulation modes work without warnings
        function testSimulationModes(testcase)
            import matlab.unittest.constraints.IssuesNoWarnings          
            testcase.verifyThat(@() testcase.normalModeSim(testcase.TestModel), IssuesNoWarnings);                
            testcase.verifyThat(@() testcase.acceleratorModeSim(testcase.TestModel), IssuesNoWarnings);  
            testcase.verifyThat(@() testcase.rapidAccelModeSim(testcase.TestModel), IssuesNoWarnings);       
            testcase.verifyThat(@() testcase.silModeSim(testcase.TestModel), IssuesNoWarnings);                              
        end
        
        % Check basic contents of SIL interface header 
        % - this will generate code
        %
        % This test model will have static data defined in the interface
        % (see patterns below).
        function testInterfaceHeader(testcase)  
            import matlab.unittest.constraints.IssuesNoWarnings
                       
            % model build should produce no warnings
            testcase.verifyThat(@() testcase.generateCode(), IssuesNoWarnings);                
            
            % Check for correct layout of Event table (must occur in this order)            
            patterns(1).FileName = [testcase.TestInterface];          
            patterns(1).ContainsOrderedStrings = { ...                     
                '#define ECI_EVENT_TABLE_DEFINED        1' , ...
                'static const ECI_Evs_t ECI_Events[] = {' , ...
                '{ EVENT_message4_ID,' , ...
                '&EventAtTop_ConstP.CFS_Event_event_id,' , ...
                '&EventAtTop_ConstP.pooled3,' , ...
                '&EventAtTop_ConstP.pooled2,' , ...
                '&evFlag_EventAtTop_222,' , ...
                'EventAtTop_ConstP.pooled4,' , ...
                '"EventAtTop/AtomicSubsystem/CFS_Event",' , ...
                '&evData_EventAtTop_222[0],' , ...
                '&evData_EventAtTop_222[1],' , ...
                '&evData_EventAtTop_222[2],' , ...
                '&evData_EventAtTop_222[3],' , ...
                '0' , ...
                '},' , ...
                '{ EVENT_message4_ID,' , ...
                '&EventAtTop_ConstP.CFS_Event_event_id_a,' , ...
                '&EventAtTop_ConstP.pooled3,' , ...
                '&EventAtTop_ConstP.pooled2,' , ...
                '&evFlag_EventAtTop_212,' , ...
                'EventAtTop_ConstP.pooled4,' , ...
                '"EventAtTop/CFS_Event",' , ...
                '&evData_EventAtTop_212[0],' , ...
                '&evData_EventAtTop_212[1],' , ...
                '&evData_EventAtTop_212[2],' , ...
                '&evData_EventAtTop_212[3],' , ...
                '0' , ...
                '},' , ...
                '{ EVENT_message0_ID,' , ...
                '&EventAtTop_ConstP.CFS_Event1_event_id,' , ...
                '&EventAtTop_ConstP.pooled3,' , ...
                '&EventAtTop_ConstP.pooled2,' , ...
                '&evFlag_EventAtTop_213,' , ...
                'EventAtTop_ConstP.CFS_Event1_event_fmtstring,' , ...
                '"EventAtTop/CFS_Event1",' , ...
                '0,' , ...
                '0,' , ...
                '0,' , ...
                '0,' , ...
                '0' , ...
                '},' , ...
                '{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }' , ...
                '};            '    };
            
            testcase.checkCodeContents(patterns);
        end        

    end
end
