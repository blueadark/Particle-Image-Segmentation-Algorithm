function [output_1,output_2,output_3,output_4] = f_index(grain_segment,I_ann)
%计算精准率，召回率以及F1分数
grain_segment(grain_segment~=0)=1;
I_ann(I_ann~=0)=1;
intersection=grain_segment & I_ann;
union = grain_segment | I_ann;
precesion=sum(intersection(:))/sum(grain_segment(:));
recall = sum(intersection(:))/sum(I_ann(:));
F1=2*(precesion*recall)/(precesion+recall);
IoU=sum(intersection(:))/sum(union(:));
output_1 = precesion;
output_2 = recall;
output_3 = F1;
output_4 = IoU;
end

