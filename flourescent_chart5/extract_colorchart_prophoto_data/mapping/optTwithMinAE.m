function [T, fval] = optTwithMinAE(source, target, varargin)



if nargin==3
    saturation = varargin{1};
else 
    saturation = Inf;
end

% exclude the potentially saturated patches
max_raw = max(source,[],2);
used = max_raw<saturation;

% min_raw = min(source,[],2);

source_used = source(used,:);
target_used = target(used,:);

target_used_norm = sqrt(sum(target_used.^2,2));

T0 = diag(target_used(1,:)./source_used(1,:));

angular_error_between_src_dst(source, target)

options = optimoptions(@fminunc,'Algorithm','quasi-newton','MaxFunEvals',5000,'TolX',1e-10,'TolFun', 1e-8);
[T,fval,exitflag,output] = fminunc(@mapping_error,T0,options);

function f = angular_error_between_src_dst(source, target)
    target_norm = sqrt(sum(target.^2,2));
    source_mapped_norm = sqrt(sum(source.^2,2));
    f = sum(source .* target,2)./(source_mapped_norm.*target_norm);
    f(f>1)=1;
    f = acosd(f);
    f = sum(f);
end

function f = mapping_error(T)
    source_mapped = source_used*T;
    source_mapped_norm = sqrt(sum(source_mapped.^2,2));
    f = sum(source_mapped .* target_used,2)./(source_mapped_norm.*target_used_norm);
    f(f>1)=1;
    f = acosd(f);
    f = sum(f);
end

source_mapped = source_used*T;

s = reshape(source_mapped(:,:),[],1)\reshape(target_used(:,:),[],1);
% s = mean(reshape(target_used(:,:),[],1))/ mean(reshape(source_mapped(:,:),[],1));
T = T.*s;

end