
    imageArray = cell(1,100);  
    trainingData = cell(1,100);  
    myFolder = 'C:\Users\ahmedelsayed\Desktop\ASS1_PR\MyPic';
    if ~isdir(myFolder)
     errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
     uiwait(warndlg(errorMessage));
     return;
     end
     filePattern = fullfile(myFolder, '*.bmp');
     jpegFiles = dir(filePattern);
     for k = 1:length(jpegFiles)
     baseFileName = jpegFiles(k).name;
     fullFileName = fullfile(myFolder, baseFileName);
     fprintf(1, 'Now reading %s\n', fullFileName);
     x = imread(fullFileName);
     imageArray{k} = ~x;
     

     im = imageArray{k};
           
        [r c]=size(im);

        nRows = size(im, 1);
        nCols = size(im, 2);



        [r c]=size(im);

        row_div = 3;
        col_div = 2;

        roR = rem(nRows , row_div);
        ioR = floor(nRows/row_div);

        roC = rem(nCols , col_div);
        ioC = floor(nCols/col_div);

        vectors = mat2cell(im , [(ioR*ones(1,row_div )) roR] ,[(ioC*ones(1, col_div)) roC]);
    
        photoTrainingData = cell(1,size(vectors));
        
        rr = row_div;
        cc = col_div;
        
        
        for i=1:rr
          for j=1:cc
            vec = vectors(i,j);
                disp(vec);
                total1 = 0;
                total2 = 0;
                total3 = 0;
                
            for xx=1:ioR
              for yy=1:ioC
                
                total1 = total1 + vec{1,1}(xx,yy);
                total2 = total2 + (xx * vec{1,1}(xx,yy));

                total3 = total3 + (yy * vec{1,1}(xx,yy));


                end
              end

           if total1==0
             normal_x = 0.5;
             normal_y = 0.5;
           else
             
             res_x = total2 / total1 ;
             res_y = total3 / total1;      
             normal_x = res_x / double(ioR);
             normal_y = res_y / double(ioC);
            
             
           end
           
           photoTrainingData{i,j} = {normal_x , normal_y};
          end
        end
       
        trainingData{k} = {photoTrainingData,floor((k-1)/10)};


     %imshow(imageArray(1));  % Display image.
     %drawnow; % Force display to update immediately.
    
  end
  
    
%//////////////////////////////////////////////////////////////////////

   
   testPh = ~imread('C:\Users\ahmedelsayed\Desktop\ASS1_PR\98.bmp');
        
        
        [tr tc]=size(testPh);

        tnRows = size(testPh, 1);
        tnCols = size(testPh, 2);

        trow_div = 3;
        tcol_div = 2;

        troR = rem(tnRows , trow_div);
        tioR = floor(tnRows/trow_div);

        troC = rem(tnCols , tcol_div);
        tioC = floor(tnCols/tcol_div);


        testvectors = mat2cell(testPh , [(tioR*ones(1,trow_div )) troR] ,[(tioC*ones(1, tcol_div)) troC]);
        
        testphotoTrainingData = cell(1,size(testvectors));
        
        trr = trow_div;
        tcc = tcol_div;
        
        
        for ti=1:trr
          for tj=1:tcc
            testvec = testvectors(ti,tj);
                disp(testvec);
                testtotal1 = 0;
                testtotal2 = 0;
                testtotal3 = 0;
                
            for txx=1:tioR
              for tyy=1:tioC
                
                testtotal1 = testtotal1 + testvec{1,1}(txx,tyy);
                testtotal2 = testtotal2 + (txx * testvec{1,1}(txx,tyy));

                testtotal3 = testtotal3 + (tyy * testvec{1,1}(txx,tyy));


                end
              end

           if testtotal1==0
             testnormal_x = 0.5;
             testnormal_y = 0.5;
           else
             
             testres_x = testtotal2 / testtotal1 ;
             testres_y = testtotal3 / testtotal1;      
             testnormal_x = testres_x / double(tioR);
             testnormal_y = testres_y / double(tioC);
            
             end
           
           testphotoTrainingData{ti,tj} = {testnormal_x , testnormal_y};
          end
        end
        
             
    %////////////////////////////////////////////////////
    
    figure;
    imshow(testPh);  
    
    %///////////////////////////////////////////////////
    
    dimVec = cell(1,100);
    
    min = 1000;
    index = 0;
    for i=1:100
        dim = 0;
        d = trainingData{i}(1,1);
        dd = trainingData{i}(1,2);
            for ttxx=1:trow_div
              for ttyy=1:tcol_div
                
                
                dim = dim + abs(testphotoTrainingData{ttxx, ttyy}(1,1){1,1} - d{1,1}{ttxx,ttyy}(1,1){1,1}) + abs(testphotoTrainingData{ttxx, ttyy}(1,2){1,1} - d{1,1}{ttxx,ttyy}(1,2){1,1});
              end
            end
            if dim < min
              min = dim;
              index = i;
            end
            
              
            dimVec{i} = {dim , dd};
         end
            
    disp(dimVec);        
    disp (min);
    disp (index);
    disp(dimVec{index}(1,2));

  