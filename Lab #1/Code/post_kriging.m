function [u_cal, v_cal] = post_kriging(img_size, X, Y, u, v)
    uqlab;

    MetaOpts.Type = 'Metamodel';
    MetaOpts.MetaType = 'Kriging';
    MetaOpts.ExpDesign.Sampling = 'User';

    idu = not(isnan(u));
	idv = not(isnan(v));
    MetaOpts.ExpDesign.X = [X(idu),Y(idu)];
    MetaOpts.ExpDesign.Y = u(idu);

    %%%%%%%%%%%%%%%%%%% 给定Trend %%%%%%%%%%%%%%%%%%%%%%%%%%
    MetaOpts.Trend.Type='ordinary';
    % MetaOpts.Trend.Degree=2;
    %%%%%%%%%%%%%% 给定估计方法——计算\theta %%%%%%%%%%%%%%%%%%%%%%%
    MetaOpts.EstimMethod='CV';              % Default:CV
    MetaOpts.CV.LeaveKOut=1;                % 如果用的是交叉验证，定义leave k out
    %%%%%%%%%%%%%%%%% 给定优化方法 %%%%%%%%%%%%%%%%%%%%%%%%%%
    MetaOpts.Optim.Method='CMA-ES';
    MetaOpts.Optim.InitialValue = 5;
    MetaOpts.Optim.Bounds=[1E-2;1E2];
    
    % Create Kriging metamodel
    KrigModel = uq_createModel(MetaOpts);
    u_cal(not(idu)) = uq_evalModel(KrigModel, [X(not(idu)),Y(not(idu))]);

end