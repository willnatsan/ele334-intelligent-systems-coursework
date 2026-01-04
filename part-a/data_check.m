final_fis = readfis('santoso_part_A_section_d.fis');

ty=evalfis(trdata(:,1:2),final_fis);
cy=evalfis(ckdata(:,1:2),final_fis);

t_error=trdata(:,3)-ty;
c_error=ckdata(:,3)-cy;

MAE_Training = mae(t_error)
MAE_Checking = mae(c_error)

RMSE_Training = rms(t_error)
RMSE_Checking = rms(c_error)