function [label_idx,scores] = train_grain(img_name,slic,T)
    %% ������������
    m1=[77.1993;46.5755]; %ǰ����ֵ
    C1=[0.0032 -0.0058;-0.0058 0.0228];%ǰ��Э�������
    m2=[2.3856;2.4703]; %������ֵ
    C2=[0.1071,-0.1358;-0.1358,0.2346]; %����Э�������

    %% ��ȡͼ��
    I=double(img_name);
    num_pixels=max(max(slic));%���طֿ�����
    %% �ֱ����ÿ�����ص�����ǰ�����ʺͱ����ĸ���
    
    x1=zeros(2,1);
    x2=zeros(2,1);
    size1=size(I);
    lab=zeros(size1(1),size1(2),3);
    lab(:,:,2)=I(:,:,1)-I(:,:,3);
    lab(:,:,3)=I(:,:,2)-I(:,:,3);
    p1=zeros(size1(1),size1(2));
    p2=zeros(size1(1),size1(2));
    for i=1:size1(1)
        for j=1:size1(2)
                x1(1)=lab(i,j,2)-m1(1);
                x1(2)=lab(i,j,3)-m1(2);
                temp=-0.5*x1'*C1*x1;
                p1(i,j)=exp(temp);%����������ڹ����ĸ���

                x2(1)=lab(i,j,2)-m2(1);
                x2(2)=lab(i,j,3)-m2(2);
                temp=-0.5*x2'*C2*x2;
                p2(i,j)=exp(temp);%����������ڱ����ĸ���

        end
    end

    %% �����ط���

    %����ǩ����L����������ת��Ϊ��������
    idx = label2idx(slic);
    numRows = size(I,1);
    numCols = size(I,2);
    % �Ա���������ǰ���������б�ע
    classifier1=zeros(numRows,numCols);%���ǰ����
    classifier2=zeros(numRows,numCols);%��Ǳ�����
    label=zeros(num_pixels,1);
    temp=zeros(num_pixels,4);
    for labelVal=1:num_pixels
        count=idx{labelVal};
        temp(labelVal,1)=sum(p1(count));
        temp(labelVal,2)=sum(p2(count));
        temp(labelVal,3)=size(count,1);
        temp(labelVal,4)=temp(labelVal,1)/size(count,1);
        temp(labelVal,5)=temp(labelVal,2)/size(count,1);
        temp_max=max(temp(labelVal,4),temp(labelVal,5));
        temp_min=min(temp(labelVal,4),temp(labelVal,5));
        temp(labelVal,6)=temp_max*(1+(log(temp_max/temp_min)));

        if temp(labelVal,4)>temp(labelVal,5) && temp(labelVal,6)>T
           classifier1(count)=1;
           label(labelVal)=1;
        elseif temp(labelVal,5)>temp(labelVal,4) && temp(labelVal,6)>T
           classifier2(count)=1;
           label(labelVal)=-1;
        else
           continue; 
        end

    end
    scores=temp;
    label=num2cell(label);
    label_idx=[idx;label'];


end

