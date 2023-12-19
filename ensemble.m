function result=ensemble(result_idx,C_C,I)

    % 颜色分类
    I3=double(I);
    divide_C=256/C_C;
    red=floor(I3(:,:,1)/divide_C);
    green=floor(I3(:,:,2)/divide_C);
    blue=floor(I3(:,:,3)/divide_C);
    apart_color=(C_C-1)*C_C^2+(C_C-1)*C_C+(C_C-1)*1+1;%代表颜色直方图全部类别数目
    pixel_color=red*1+green*C_C+blue*C_C^2+1;
    N=size(result_idx,2);
    data=zeros(N,apart_color);
    for labelVal=1:N
        temp1=result_idx{1,labelVal};
        temp2=pixel_color(temp1);
        h=tabulate(temp2);
        data(labelVal,h(:,1))=h(:,2);
    end
%% 提取数据
    [~,train_1]=find(cell2mat(result_idx(2,:))~=0);
    [~,test_1]=find(cell2mat(result_idx(2,:))==0);
    training_data=data(train_1,:);
    training_label=cell2mat(result_idx(2,train_1));
    training_label=training_label';
    test_data=data(test_1,:);
    
%% LogitBoost
    ensemble=fitcensemble(training_data,training_label,...
                            'LearnRate',0.1,...
                            'ScoreTransform','none',...
                            'NumLearningCycles',500);
     
    [yfit,score]=predict(ensemble,test_data);
    test_labels=num2cell(yfit,2);
    result_idx(2,[test_1])=test_labels;
    result=result_idx;
end
    
