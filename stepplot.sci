

function stepplot(varargin)
    [lhs,rhs]=argn(0)
    s=%s
    x = poly(0,'x')
    finalTimeFlag = %t
    if rhs == 0 | (rhs == 1 & typeof(varargin($)) <> ['state-space', 'rational'] | (rhs == 1 & size(varargin($)) == [0 0])) then
        error(msprintf(gettext("%s: Wrong type for input argument \n#%d: State-space or transfer function of linear system expected.\n"),"stepplot",1))
    end
    if typeof(varargin(1)) <> ['state-space','rational'] then
        error(msprintf(gettext("%s: Wrong type for first input argument\n#%d: State-space or transfer function expected.\n"),"stepplot",1))
    end
    //finding the tfinal or vector of time
    totalTime = 0:0.1:1000-0.1; 
    if rhs > 1 then
        if typeof(varargin($)) == 'constant' then
            if size(varargin($)) == [1 1] then
                if varargin($) <= 0 then
                    error(msprintf(gettext("%s: The final time value must be a positive real number.\n"),"stepplot"))
                end
                tFinal = varargin($)
                totalTime =0:0.01:tFinal; 
            elseif isequal(size(varargin($)),[1 1]) == %f then
                // finding that the time vector has positive time value
                tempTimeIndex = find(varargin($) >= 0)
                if isequal(size(varargin($)),size(tempTimeIndex)) == %t then
                    totalTime = varargin($)
                else
                    tempTime = varargin($)
                    tempTime = tempTime(tempTimeIndex(1):tempTimeIndex($))
                    totalTime = tempTime
                end
            end
        end
    end
    //disp(totalTime)
    if rhs >= 1 then
        if typeof(varargin($)) == 'constant' then
            vararginIndex = rhs-1
        else
            vararginIndex = rhs
        end
    end
    
    dataIndexNumber = 1
    colorIndexNumber = 1
    colorIndex = []
    currentI = 1
    previousI = 0
    for ii = 1:vararginIndex
        //printf('hi')
         if typeof(varargin(ii)) == 'state-space' | typeof(varargin(ii)) == 'rational' then
             dataIndex(dataIndexNumber,1) = ii
             tempSize = size(varargin(ii))
             //disp(tempSize)
             if typeof(varargin(ii)) == 'state-space' then
                outputSize(dataIndexNumber,1) = tempSize(1,1) 
                inputSize(dataIndexNumber,1) = tempSize(1,2)
             elseif typeof(varargin(ii)) == 'rational' then
                 if isequal(tempSize,[1 1]) == %f & length(tempSize) == 2 then
                     //printf('fuck fun')
                     outputSize(dataIndexNumber,1) = tempSize(1,1) 
                     inputSize(dataIndexNumber,1) = tempSize(1,2)
                 else
                     outputSize(dataIndexNumber,1) = 1 
                     inputSize(dataIndexNumber,1) = 1
                 end
             end 
             
             if ii+1 == rhs+1 then
                 tempii = rhs
             else
                 tempii = ii+1
             end
                if typeof(varargin(tempii)) == 'string' then
                    currentI = ii+1
                        if currentI == previousI+1 then
                            error(msprintf(gettext("%s: Incorrect syntax.\n"),"stepplot"))
                        end
                    previousI = currentI
                    colorIndex(dataIndexNumber,1) = ii+1
                else
                    colorIndex(dataIndexNumber,1) = 0
                 end
             dataIndexNumber = dataIndexNumber + 1
         end
    end
    //disp(outputSize)
    //disp(inputSize)
    outputSize = max(outputSize)
    inputSize = max(inputSize)
    //subplotIndex = 100*outputSize+10*inputSize
    //disp(subplotIndex)    
    lastIndex = 0
    meanTime = []
    if isequal(zeros(length(dataIndex),1),colorIndex) == %f then
        //printf('kissme')
        [colorIndex newIndex] = gsort(colorIndex,'r')
        dataIndex = dataIndex(newIndex(:,1),1)
    end
    //disp(dataIndex)
    //-----------------------------------------------------------------------------------------------------------------
    unc = 1//unstable number counter
    tfIndex = 1//transfer function Index
    // storing the time
    for ii = 1:max(size(dataIndex))
        if typeof (varargin(dataIndex(ii,1))) == 'state-space' then
            tempVarargin = (ss2tf(minss(varargin(dataIndex(ii,1)))))'
        else
            tempVarargin = varargin(dataIndex(ii,1))
            if isequal(size(varargin(dataIndex(ii))),[1 1]) == %f & length(varargin(dataIndex(ii))) >= 4 then
                tempVarargin = tempVarargin'
            end
        end
        tempVararginSize = size(tempVarargin)
        noe = 1 // number of elements
        for jj  = 1 : length(tempVararginSize)
            noe = noe*tempVararginSize(jj)
        end
        noeCount(ii,1) = noe
        tempVararginNum = tempVarargin.num
        tempVararginDen = tempVarargin.den
        for kk = 1:noe
            denRoots = roots(poly(coeff(tempVararginDen(kk)),'x','coeff'))
            denRootsPhase = phasemag(denRoots)
            positiveRoots = find(denRootsPhase==0)
            tempTF(kk+lastIndex,1) = syslin('c',tempVararginNum(kk)/tempVararginDen(kk))
            if size(positiveRoots,'r') ~= 0 then
                finalTimeFlag = %f
                denRoots = max(denRoots)
                //finalTime = min(30*log(10)/denRoots,length(totalTime))
                //disp(finalTime)
                timeL(unc,1) = 30*log(10)/denRoots
                timeU(unc,1) = min(250*log(10)/denRoots,length(totalTime))
                unc = unc+1
                //disp(timeU)
                //tempTF(kk+lastIndex,1) = syslin('c',tempVararginNum(kk)/tempVararginDen(kk))
            else
                stepData= csim('step',totalTime,tempTF(kk+lastIndex,1))
                tempMeanData = mean(stepData)-stepData
                tempStepData = stepData
                if abs(length(find(tempMeanData>mean(tempMeanData)))-length(find(tempMeanData<mean(tempMeanData)))) < 10 then //critical stable system
                    if mean(tempStepData) >= 0 then
                        //printf('locha ye ulfat')
                        //finding the time period
                        totalIndex = find(tempStepData>=mean(tempStepData))
                        tempFirstIndex = totalIndex(1,1)
                        while(tempStepData(tempFirstIndex)>mean(tempStepData))
                            tempFirstIndex = tempFirstIndex+1
                        end
                        timePeriod = 2*(tempFirstIndex-totalIndex(1,1))
                        //disp(timePeriod)
                        tempTime = 100*timePeriod+totalIndex(1,1)
                        tempTime = min(tempTime,length(totalTime)/2)
                    elseif mean(tempStepData) < 0 then
                        //printf('ho gaya')
                        //finding the time period
                        totalIndex = find(tempStepData<mean(tempStepData))
                        tempFirstIndex = totalIndex(1,1)
                        while(tempStepData(tempFirstIndex)<mean(tempStepData))
                            tempFirstIndex = tempFirstIndex+1
                        end
                        timePeriod = 2*(tempFirstIndex-totalIndex(1,1))
                        tempTime = 100*timePeriod+totalIndex(1,1)
                        tempTime = min(tempTime,length(totalTime)/2)
                    end
                    meanTime(tfIndex,1) = tempTime                    
                elseif isequal(typeof(varargin($)),'constant') == %f then//stable systems
                    aboveMean = find(tempStepData>mean(tempStepData))
                    belowMean = find(tempStepData<mean(tempStepData))
                    findLength = min(length(aboveMean),length(belowMean))
                    if findLength == length(aboveMean) then
                        tempIndex = belowMean
                    elseif findLength == length(belowMean) then
                        tempIndex = aboveMean
                    end
                        tempCount = 0
                        for jj = findLength+1:length(tempIndex)-5
                            tempCount = 0
                            for kk = 1:5
                                if tempIndex(1,jj+kk) == tempIndex(1,jj)+kk then
                                    tempCount = tempCount+1
                                end
                                
                            end
                            if tempCount == 5 then
                                meanTime(tfIndex,1) = jj
                                break
                            end
                        end                    
                end
                //tempStepData(tfIndex,1)=stepData
                //disp(tfIndex)
                tfIndex = tfIndex+1
            end
            
            //stepData(kk+lastIndex,:)= csim('step',totalTime,tempTF(kk+lastIndex,1))
        end
        lastIndex = lastIndex+noe
    end
    //-----------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//disp(lastIndex)
//setting the final time
        if size(meanTime,'r') ~= 0 then//lastIndex <> 1 & isequal(typeof(varargin($)),'constant') == %f then
            meanTimeIndex = max(meanTime)//giving the index
            meanTime = totalTime(meanTimeIndex)
            //disp(meanTime)
        end
        if finalTimeFlag == %f then
            timeL = min(timeL)
            timeU = min(timeU)
//            printf('enter the zone  ')
            if lastIndex == 1 then
//                printf('\nlol')
//                disp(timeL)
                tFinal = timeL
            elseif lastIndex <> 1 & (timeU < meanTime | timeU > meanTime & timeL < meanTime | timeL > meanTime) then
                tFinal = timeU
            end
            //setting the final time 
            if timeU < 10 then
                timeStep = timeU/1000
                tempTime = 0:timeStep:timeU
            elseif tFinal > totalTime($)
                tempTime = 0:tFinal
            else
                //disp(tFinal)
                tempTimeIndex = find(totalTime<=tFinal)
                tempTime = totalTime(tempTimeIndex)
            end
        else
            tempTime = totalTime(1:meanTimeIndex)
//            disp(tempTime($))
        end
        //disp((tempTime($)))
        //disp(lastIndex)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // if end time or time data is give.
    if isequal(typeof(varargin($)),'constant') == %t then
        if finalTimeFlag == %f then
            if totalTime($) > tFinal then
                tempTimeIndex = find(totalTime<tFinal)
                tempTime = totalTime(tempTimeIndex)
            end
        end
    else
        //tempTime = totalTime
    end
//    disp(size(tempTime))
//    disp(lastIndex)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
stepData = []
// collecting the step Data
        for ii = 1 : lastIndex
            stepData(ii,:) = csim('step',tempTime,tempTF(ii,1)) 
        end
    stepDataIndex = 1
    colorDataIndex = 1
    for ii = 1:length(dataIndex)
        if typeof(varargin(dataIndex(ii))) == 'state-space' then
            //printf('\nhi')
            ssTempSize = size(varargin(dataIndex(ii)))
            outputIndex = ssTempSize(1,1)
            inputIndex = ssTempSize(1,2)
            countIndex = inputIndex
            tempSubplotIndex = 0
            colorDataIndex = colorDataIndex + 1
            for jj = 1 : inputIndex
                for kk = 1 : outputIndex
                    if inputIndex < inputSize then
                        if tempSubplotIndex < countIndex then
                            tempSubplotIndex = tempSubplotIndex + 1
                        else
                            countIndex = countIndex+inputSize
                            tempSubplotIndex = tempSubplotIndex + inputSize - inputIndex+1
                        end
                    else
                        tempSubplotIndex = tempSubplotIndex+1
                    end
                    if colorIndex(ii,1) == 0 then
                        subplot(outputSize,inputSize,tempSubplotIndex);plot(tempTime,stepData(stepDataIndex,:))
                            last_line = gce()
                            last_line.children.foreground = colorDataIndex
                            
                            xgrid()
                    else
                        selectColor = varargin(colorIndex(ii,1))
                        subplot(outputSize,inputSize,tempSubplotIndex);plot(tempTime,stepData(stepDataIndex,:),selectColor)
                    end
                    stepDataIndex = stepDataIndex + 1
                end
            end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////            
        elseif typeof(varargin(dataIndex(ii))) == 'rational' then
            tempSubplotIndex = 0
            if isequal(size(varargin(dataIndex(ii))),[1 1]) == %f & length(varargin(dataIndex(ii))) >= 4 then
                tfTempSize = size(varargin(dataIndex(ii)))
                outputIndex = tfTempSize(1,1)
                inputIndex = tfTempSize(1,2)
                countIndex = inputIndex
                colorDataIndex = colorDataIndex+1
                for jj = 1:inputIndex
                    for kk = 1 : outputIndex
                        
                        if inputIndex < inputSize then
                            if tempSubplotIndex < countIndex
                                tempSubplotIndex = tempSubplotIndex+1
                            else
                                countIndex = countIndex+inputSize
                                tempSubplotIndex = tempSubplotIndex + inputSize - inputIndex+1
                            end
                        else
                            tempSubplotIndex = tempSubplotIndex + 1
                        end
                        if colorIndex(ii,1) == 0 then
                            subplot(outputSize,inputSize,tempSubplotIndex);plot(tempTime,stepData(stepDataIndex,:))
                                last_line = gce()
                                disp(last_line.children.foreground)
                                disp(last_line.user_data)
                                //disp(last_line.children)
                                last_line.children.foreground = colorDataIndex
                                
                        else
                            //last_line = gce()
                            //disp(last_line.children.foreground)
                            selectColor = varargin(colorIndex(ii,1))
                            subplot(outputSize,inputSize,tempSubplotIndex);plot(tempTime,stepData(stepDataIndex,:),selectColor)
                        end
                        stepDataIndex = stepDataIndex + 1                        
                    end
                end
                 
            else
                tempSubplotIndex = tempSubplotIndex + 1
                for jj = 1:noeCount(ii,1)
                    colorDataIndex = colorDataIndex+1
                    if colorIndex(ii,1) == 0 then
                        subplot(outputSize,inputSize,tempSubplotIndex);plot(tempTime,stepData(stepDataIndex,:))
                            last_line = gce()
                            last_line.children.foreground = colorDataIndex
                    else
                        selectColor = varargin(colorIndex(ii,1))
                        subplot(outputSize,inputSize,tempSubplotIndex);plot(tempTime,stepData(stepDataIndex,:),selectColor)
                    end                    
                    stepDataIndex = stepDataIndex + 1
                end
            end
        end
    end
    f = gcf()
    f.figure_name = "Step Plot"
    //f.parent.title = "boom"
    //f.info_message = "hi"
    //f.title
    //f.x_label
    //f.y_label
    
    //xtitle("My title","my x axis label", "Volume")
    //type(f.title)
    //disp(f)
            
endfunction







//kachara
//                            if modulo(tempSubplotIndex,outputSize) == 1 & modulo(tempSubplotIndex,inputSize) == 1 then
//                                xtitle('From: In(1)','','To:Out(1)')
//                            elseif modulo(tempSubplotIndex,inputSize) == 1 then//tempSubplotIndex <= outputSize then
//                                tempString = 'To:Out('+string(modulo(tempSubplotIndex,inputSize))+')'
//                                xtitle('','',tempString)
//                            elseif modulo(tempSubplotIndex,outputSize) == 1 then
//                                tempString = 'From:In('+string(modulo(tempSubplotIndex,outputSize))+')'
//                                xtitle(tempString,'','')
//                            end
////////////////////////////
//                            if tempSubplotIndex < countIndex then
//                                tempSubplotIndex = tempSubplotIndex + 1
//                            else
//                                countIndex = countIndex+inputSize
//                                tempSubplotIndex = tempSubplotIndex + inputSize - inputIndex+1
//                            end
                        //else
//                            tempSubplotIndex = tempSubplotIndex+1
//////////////////////////
//                                xtitle(string(tempSubplotIndex),'','')
//                                if modulo(tempSubplotIndex,outputSize) == 1 & modulo(tempSubplotIndex,inputSize) == 1 then
//                                    xtitle('From: In(1)','','To:Out(1)')
//                                elseif modulo(tempSubplotIndex,inputSize) == 1 then//tempSubplotIndex <= outputSize then
//                                    tempString = 'To:Out('+string(modulo(tempSubplotIndex,inputSize))+')'
//                                    xtitle('','',tempString)
//                                elseif modulo(tempSubplotIndex,outputSize) == 1 then
//                                    tempString = 'From:In('+string(modulo(tempSubplotIndex,inputSize))+')'
//                                    xtitle(tempString,'','')
//                                end                                
//                                if modulo(tempSubplotIndex,outputSize) == 1 & modulo(tempSubplotIndex,inputSize) == 1 then
//                                    xtitle('From: In(1)','','To:Out(1)')
//                                elseif tempSubplotIndex <= outputSize then
//                                    tempString = 'To:Out('+string(tempSubplotIndex)+')'
//                                    xtitle('','',tempString)
//                                end
                                //xtitle('Step Response','','bye')
///////////////////////////

//        figure(1)
//        xtitle('Step Response')
        //title('my title')//,'position',[0.3 0.8]);
//            disp(outputIndex)
//            disp(inputIndex)
//            disp(outputSize)
//            disp(inputSize)
    //disp(size(tempStepData))
    //disp(tempTF)
////    if isequal(typeof(varargin($)),'constant') == %f then
////        //if finalTimeFlag == %t then
////            for ii = 1:lastIndex
////                tempMeanData = mean(stepData(ii,:))-stepData(ii,:)
////                tempStepData = stepData(ii,:)
////                if abs(length(find(tempMeanData>mean(tempMeanData)))-length(find(tempMeanData<mean(tempMeanData)))) <= 10 then
//////                    if mean(tempStepData) >= 0 then
//////                        printf('locha ye ulfat')
//////                        totalIndex = find(tempStepData>=mean(tempStepData))
//////                        tempFirstIndex = totalIndex(1,1)
//////                        while(tempStepData(tempFirstIndex)>mean(tempStepData))
//////                            tempFirstIndex = tempFirstIndex+1
//////                        end
//////                        timePeriod = 2*(tempFirstIndex-totalIndex(1,1))
//////                        //disp(timePeriod)
//////                        tempTime = 100*timePeriod+totalIndex(1,1)
//////                        tempTime = min(tempTime,length(totalTime)/2)
//////                    elseif mean(tempStepData) < 0 then
//////                        printf('ho gaya')
//////                        totalIndex = find(tempStepData<mean(tempStepData))
//////                        tempFirstIndex = totalIndex(1,1)
//////                        while(tempStepData(tempFirstIndex)<mean(tempStepData))
//////                            tempFirstIndex = tempFirstIndex+1
//////                        end
//////                        timePeriod = 2*(tempFirstIndex-totalIndex(1,1))
//////                        tempTime = 100*timePeriod+totalIndex(1,1)
//////                        tempTime = min(tempTime,length(totalTime)/2)
//////                    end
//////                    meanTime(ii,1) = tempTime
////    
////    
////                else
////                    //printf('\nhook up')
//////                    tempDiff = tempMeanData(1,:)-tempMeanData($)
//////                    aboveMean = find(tempStepData>mean(tempStepData))
//////                    belowMean = find(tempStepData<mean(tempStepData))
//////                    findLength = min(length(aboveMean),length(belowMean))
//////                    if findLength == length(aboveMean) then
//////                        tempIndex = belowMean
//////                    elseif findLength == length(belowMean) then
//////                        tempIndex = aboveMean
//////                    end
//////                        tempCount = 0
//////                        for jj = findLength+1:length(tempIndex)-5
//////                            tempCount = 0
//////                            for kk = 1:5
//////                                if tempIndex(1,jj+kk) == tempIndex(1,jj)+kk then
//////                                    tempCount = tempCount+1
//////                                end
//////                                
//////                            end
//////                            if tempCount == 5 then
//////                                meanTime(ii,1) = jj
//////                                break
//////                            end
//////                        end                                
////                end
////    
////            end
//        meanTime = max(meanTime)
//        totalTime = totalTime(1:meanTime)
//        stepData = stepData(:,1:meanTime)
//        //else 
//        //    tempTime = find(totalTime>finalTime)
//         //   meanTime=tempTime(1)
//        //end
//
//    end
//disp(meanTime)
//disp(lastIndex)

//    disp(size(tempTF))
//    disp(tempTF)
//    disp(lastIndex)
//    //disp(noeCount)
    //save('tra1.dat',stepData);
    //--------------------------------------------------------------------------
    //step data from csim
    //for ii = 1:lastIndex
        //stepData(ii,:) = csim('step',totalTime,tempTF(ii,1))
    //end
    
    
    //--------------------------------------------------------------------------
//                
//                if finalTime <=0.01 then
//                    timeStep = finalTime/10
//                    totalTime = 0:timeStep:finalTime
////                    //tempTime = totalTime
//                else
//                    totalTime = 0:0.01:finalTime
//                    //meanTime(ii,1) = finalTime
//                end
                //tempTF(kk+lastIndex,1) = syslin('c',tempVararginNum(kk)/tempVararginDen(kk))
                //stepData(kk+lastIndex,:)= csim('step',tempTime,tempTF)
            //else
            
            
            
            
//            tempTF = syslin('c',tempVararginNum(kk)/tempVararginDen(kk))
//            stepData(kk+lastIndex,:)= csim('step',totalTime,tempTF)
        //denPoly = poly(coeff(tempVarargin.den),'s','coeff')
        //disp(roots(denPoly))
        //denRoots = roots(tempVarargin.den)
        //disp(denRoots)
                //plot(tempDiff)
                //disp(size(tempStepData))
                //tempDiffIndex = find(tempDiff>0.00001)
                //disp(tempDiffIndex($))
                
            //disp(outputIndex)
            //disp(inputIndex)
//                printf('hi hook')
//                firstIndex = find(tempMeanData>mean(tempMeanData))
//                //disp(firstIndex(1,1))
//                tempFirstIndex = firstIndex(1,1)
//                while(tempMeanData(tempFirstIndex)>mean(tempMeanData))
//                    tempFirstIndex = tempFirstIndex+1
//                end
//                disp(firstIndex(1,1))
//                disp(tempFirstIndex)
//                disp(mean(tempMeanData))
//                disp(tempMeanData(tempFirstIndex))
//                disp(tempFirstIndex-firstIndex(1,1))
//                printf('\n---------------------------')
//                firstIndex = find(tempStepData>mean(tempStepData))
//                tempFirstIndex = firstIndex(1,1)
//                while(tempStepData(tempFirstIndex)>mean(tempStepData))
//                    tempFirstIndex = tempFirstIndex+1
//                end
//                disp(firstIndex(1,1))
//                disp(tempFirstIndex)
//                disp(mean(tempStepData))
//                disp(tempStepData(tempFirstIndex))
//                disp(tempFirstIndex-firstIndex(1,1))                

                    
                        
                        
                    //disp(length(aboveMean))
                    //disp(length(belowMean))
                    //disp(belowMean($))
                    //disp(mean(tempStepData)-tempStepData($))
//                    for jj = 1:length(tempStepData)-5
//                        for kk = 1:5
//                            if abs(mean(tempStepData)-tempStepData(1,ii+jj)) < 0.01 then
//                                tempCount = tempCount+1
//                            end 
//                        end
//                        tempCount = 0
//                    end
//                    disp(jj)
                    
            //plot(totalTime,)
            //plot(length(find((tempMeanData > mean(tempMeanData)-10^-15) & (tempMeanData < mean(tempMeanData))+10^-15)))
            //disp(find(tempMeanData == mean(tempMeanData)))
            //disp(mean(stepData(ii,:)))
            //disp((max(stepData(ii,:))))
            //disp((min(stepData(ii,:))))
            //disp(variance(stepData(ii,:)),'c')
            //disp(variance(tempMeanData,'r'))
            //figure (2)
            //plot(totalTime,gsort(tempMeanData))
            //[tempDataStore tempDataStoreIndex]= gsort(tempMeanData)
            //hifi = find(tempDataStore >= tempDataStore(1,1)-10^-6)
            //disp(()))
            //disp(hifi)
            //disp(tempDataStoreIndex(hifi(:,:)))
            //disp(tempDataStore(1,1))
            //last_line = gce()
            //last_line.children.foreground =ii            
            //figure (3)
            //plot
            //disp(mean(tempMeanData))
            //disp(isequal((tempMeanData)-mean(tempMeanData),tempMeanData))
            //plot(totalTime,(tempMeanData)-mean(tempMeanData))
            //last_line = gce()
            //last_line.children.foreground =ii
                
            //disp('---------')
            //if mean(stepData(ii,:)) >= 0 then
            //    tempMeanDataIndex = find(tempMeanData <= mean(tempMeanData))
            //elseif mean(stepData(ii,:)) < 0 then
            //    tempMeanDataIndex = find(tempMeanData > mean(tempMeanData))
            //end
            //tempCount = 0
            //for jj = 1:length(tempMeanDataIndex)-5
            //    for kk = 1:5
            //        if tempMeanDataIndex(1,jj)+kk == tempMeanDataIndex(1,jj+kk) then
            //            tempCount = tempCount+1
            //        end
            //    end
            //    if tempCount == 5 then
            //        meanTime(ii,1) = tempMeanDataIndex(1,jj) 
            //        break
            //    end
            //end
//                tempTime = 100*timePeriod+totalIndex(1,1)
//                disp(tempTime)
//                disp(size(totalTime))
//                totalTime = totalTime(1:tempTime)
//                stepData = stepData(:,1:tempTime)                
//disp(meanTime)
//disp(length(dataIndex))                    
    
//    disp(dataIndex)
//    disp(colorIndex)
//    disp(noeCount)
   //meanTime = max(meanTime)
    //plot(totalTime(1:meanTime)',stepData(:,1:meanTime)')
    //plot(totalTime',stepData')


                //disp(meanTime)
    //disp(avgTime)
    //plot(totalTime(1:max(avgTime))',stepData(:,1:max(avgTime))')
//    if isequal(typeof(varargin($)),'constant') == %f then
//        for ii = 1 : lastIndex
//            tempMean = mean(stepData(ii,:))
//            disp(tempMean)
//            if tempMean >= 0 then
//                tempMeanIndex = find(stepData(ii,:)>=tempMean)
//            else
//                tempMeanIndex = find(stepData(ii,:)<tempMean)
//            end
//            entryFlag = 0
//            for jj = 1:length(tempMeanIndex)-1
////                disp(tempMeanIndex(jj:jj+10))
//                if stepData(ii,tempMeanIndex(jj)) == stepData(ii,tempMeanIndex(jj:jj+1))
//                    if entryFlag == 0 then
//                        meanTime(ii,1) = tempMeanIndex(jj)
//                    end
//                    entryFlag = entryFlag+1
//                end
//            end
//        end
//    end
//    disp(meanTime)
//    disp(length(totalTime))

    //for ii = 1:lastIndex
      //  tempStepData = stepData(ii,:)
        //disp(size(tempStepData))
        //disp(size(totalTime))
        //disp("----")
        //plot(totalTime',stepData') 
    //end
//
    //disp(size(stepData))
    //disp(dataIndex)
    //disp(colorIndex)
//    if typeof(varargin($)) == 'constant' then
//        
//    else
//        
//    end
//    
//    y = []
//    s = %s
//    t = [0:0.01:1000]'
//    sys1 = syslin('c',1/(s+1))
//    sys2 = syslin('c',1/((s+1)^2))//+2))
//    y1 = csim('step',t,sys1)
//    y2 = csim('step',t,sys2)
//    index1 = find(mean(y1(1:$))<=y1)
//    index2 = find(mean(y2(1:$))<=y2)
//    finalindex = max(index1(1),index2(1))
//    disp(length(y1(1:finalindex)))
//    disp(length(y2(1:finalindex)))
//    disp(length(t(1:finalindex)))
//    plot2d(t(1:finalindex),y1(1:finalindex))// y2(1:finalindex)]) //(1,1))
//    plot2d(t(1:finalindex),y2(1:finalindex))//(2,1))
                                //printf('\n flying kiss')
                                //disp(last_line.children.foreground)
                                        //disp(dataIndex(ii))
        //disp(colorIndex(ii))
        //tempSubplotIndex = 1
                    //disp(size(varargin(dataIndex(ii))))
            //disp(length(varargin(dataIndex(ii)))) 
                            //printf('\n flying kiss')
                            //disp(last_line.children.foreground)
                            
                                            //plot(tempMeanData)
                //disp(tempMeanData($))    
    //disp(dataIndex)
    // sorting the color
