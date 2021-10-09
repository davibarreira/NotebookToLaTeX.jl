function createtemplate(template=:book, path=".")

    if template == :book
        tex = """
%! TeX program = lualatex
\documentclass[12pt, oneside]{book}

\usepackage{listings}

\pagestyle{plain}
\usepackage{pdfpages}
\usepackage{titlesec}

\usepackage[square,numbers]{natbib}
\usepackage[pdftex,bookmarks=true,bookmarksopen=false,bookmarksnumbered=true,colorlinks=true,linkcolor=blue]{hyperref}
\usepackage[utf8]{inputenc}
\usepackage{float}
\usepackage{enumerate}

%%%%%%% JULIA %%%%%%%%%%
\input{julia_font}
\input{julia_listings}
\input{julia_listings}
\input{julia_listings_unicode}

\lstdefinelanguage{JuliaLocal}{
    language = Julia, % inherit Julia lang. to add keywords
    morekeywords = [3]{thompson_sampling}, % define more functions
    morekeywords = [2]{Beta, Distributions}, % define more types and modules
}
%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%% BOOK INFORMATION %%%%%%%%%%
\newcommand{\authorname}{Name}
\newcommand{\booktitle}{Title}
\newcommand{\subtitle}{Subtitle}
\newcommand{\publisher}{TBD}
\newcommand{\editionyear}{2021}
\newcommand{\isbn}{XYZ}   % replace this with your own ISBN

\title{\booktitle}
\author{\authorname}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\begin{document}

% \includepdf{cover.pdf}

\frontmatter
\input{frontmatter/titlepage}
\input{frontmatter/copyright}
% \include{preface}

\newpage
\tableofcontents

\mainmatter
\newpage


\bibliography{ref}

\bibliographystyle{plainnat}

\include{appendix}

\end{document}
            """

    elseif template == :mathbook
        tex = """
%! TeX program = lualatex
\documentclass[12pt, oneside]{book}

\usepackage{listings}

\pagestyle{plain}
\usepackage{pdfpages}
\usepackage{titlesec}

%%%% MATH PACKAGES %%%%

\usepackage{amsfonts, amsthm,amsmath,amssymb,mathtools}
\usepackage{bbm}
\usepackage{bm}
\usepackage{mathtools}
\usepackage{thmtools} % List of Theorems

%%%%%%%%%%%%%%%%%%%%%%%

\usepackage[square,numbers]{natbib}
\usepackage[pdftex,bookmarks=true,bookmarksopen=false,bookmarksnumbered=true,colorlinks=true,linkcolor=blue]{hyperref}
\usepackage[utf8]{inputenc}
\usepackage{float}
\usepackage{enumerate}

%%%%%%% JULIA %%%%%%%%%%
\input{julia_font}
\input{julia_listings}
\input{julia_listings_unicode}

\lstdefinelanguage{JuliaLocal}{
    language = Julia, % inherit Julia lang. to add keywords
    morekeywords = [3]{thompson_sampling}, % define more functions
    morekeywords = [2]{Beta, Distributions}, % define more types and modules
}
%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%% BOOK INFORMATION %%%%%%%%%%
\newcommand{\authorname}{Name}
\newcommand{\booktitle}{Title}
\newcommand{\subtitle}{Subtitle}
\newcommand{\publisher}{TBD}
\newcommand{\editionyear}{2021}
\newcommand{\isbn}{XYZ}   % replace this with your own ISBN

\title{\booktitle}
\author{\authorname}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%% MATH STYLE  %%%%%%%%%%%%%
\newtheoremstyle{bfnote}%
  {}{}
  {}{}
  {\bfseries}{.}
  { }{\thmname{#1}\thmnumber{ #2}\thmnote{ (#3)}}
\theoremstyle{bfnote}
\newenvironment{prf}[1][Proof]{\textbf{#1.} }{\qed}
\newtheorem{theorem}{Theorem}[section]
\newtheorem{definition}[theorem]{Definition}
\newtheorem{exer}{Exercise}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{proposition}[theorem]{Proposition}

\newtheorem{note}{Note}[section]
\newtheorem{example}{Example}[section]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{document}

% \includepdf{cover.pdf}

\frontmatter
\input{frontmatter/titlepage}
\input{frontmatter/copyright}
% \include{preface}

\newpage
\tableofcontents

%\listoftheorems[onlynamed]

\mainmatter
\newpage


\bibliography{ref}

\bibliographystyle{plainnat}

\include{appendix}

\end{document}
            """
    end
    maintex = path*"/build_latex/notebooks/main.tex"
    open(maintex, "w") do f
        write(f,template)
    end
end

function createauxiliaryfiles(path = "./")
    
    juliafont = """
\usepackage{fontspec}

\newfontfamily\JuliaMono{JuliaMono}[
  UprightFont = *_Regular,
  BoldFont = *_Bold,
  Path = /home/davibarreira/.local/share/fonts/Unknown Vendor/TrueType/JuliaMono/,
  Extension = .ttf]
\newfontface\JuliaMonoRegular{JuliaMono-Regular}
\newfontface\JuliaMonoBold{JuliaMono-Bold}
\setmonofont{JuliaMono-Medium}[Contextuals=Alternate]
    """
    julialistings = """
\usepackage{listings}
\usepackage{xcolor}

\input{julia_listings_unicode} % full unicode support

\lstdefinelanguage{Julia}{
	% functions
	keywords=[3]{abs,abs2,abspath,accept,accumulate,accumulate!,acos,acos_fast,acosd,acosh,acosh_fast,acot,acotd,acoth,acsc,acscd,acsch,adjoint,adjoint!,all,all!,allunique,angle,angle_fast,any,any!,append!,apropos,ascii,asec,asecd,asech,asin,asin_fast,asind,asinh,asinh_fast,assert,asyncmap,asyncmap!,atan,atan2,atan2_fast,atan_fast,atand,atanh,atanh_fast,atexit,atreplinit,axes,backtrace,base,basename,beta,big,bin,bind,binomial,bitbroadcast,bitrand,bits,bitstring,bkfact,bkfact!,blkdiag,broadcast,broadcast!,broadcast_getindex,broadcast_setindex!,bswap,bytes2hex,cat,catch_backtrace,catch_stacktrace,cbrt,cbrt_fast,cd,ceil,cfunction,cglobal,charwidth,checkbounds,checkindex,chmod,chol,cholfact,cholfact!,chomp,chop,chown,chr2ind,circcopy!,circshift,circshift!,cis,cis_fast,clamp,clamp!,cld,clipboard,close,cmp,coalesce,code_llvm,code_lowered,code_native,code_typed,code_warntype,codeunit,codeunits,collect,colon,complex,cond,condskeel,conj,conj!,connect,consume,contains,convert,copy,copy!,copysign,copyto!,cor,cos,cos_fast,cosc,cosd,cosh,cosh_fast,cospi,cot,cotd,coth,count,count_ones,count_zeros,countlines,countnz,cov,cp,cross,csc,cscd,csch,ctime,ctranspose,ctranspose!,cummax,cummin,cumprod,cumprod!,cumsum,cumsum!,current_module,current_task,dec,deepcopy,deg2rad,delete!,deleteat!,den,denominator,deserialize,det,detach,diag,diagind,diagm,diff,digits,digits!,dirname,disable_sigint,display,displayable,displaysize,div,divrem,done,dot,download,dropzeros,dropzeros!,dump,eachcol,eachindex,eachline,eachmatch,edit,eig,eigfact,eigfact!,eigmax,eigmin,eigvals,eigvals!,eigvecs,eltype,empty,empty!,endof,endswith,enumerate,eof,eps,equalto,error,esc,escape_string,evalfile,exit,exp,exp10,exp10_fast,exp2,exp2_fast,exp_fast,expanduser,expm,expm!,expm1,expm1_fast,exponent,extrema,eye,factorial,factorize,falses,fd,fdio,fetch,fieldcount,fieldname,fieldnames,fieldoffset,filemode,filesize,fill,fill!,filter,filter!,finalize,finalizer,find,findfirst,findin,findlast,findmax,findmax!,findmin,findmin!,findn,findnext,findnz,findprev,first,fld,fld1,fldmod,fldmod1,flipbits!,flipdim,flipsign,float,floor,flush,fma,foldl,foldr,foreach,frexp,full,fullname,functionloc,gamma,gc,gc_enable,gcd,gcdx,gensym,get,get!,get_zero_subnormals,getaddrinfo,getalladdrinfo,gethostname,getindex,getipaddr,getkey,getnameinfo,getpeername,getpid,getsockname,givens,gperm,gradient,hash,haskey,hcat,hessfact,hessfact!,hex,hex2bytes,hex2bytes!,hex2num,homedir,htol,hton,hvcat,hypot,hypot_fast,identity,ifelse,ignorestatus,im,imag,in,include_dependency,include_string,ind2chr,ind2sub,indexin,indices,indmax,indmin,info,insert!,instances,intersect,intersect!,inv,invmod,invperm,invpermute!,ipermute!,ipermutedims,is,is_apple,is_bsd,is_linux,is_unix,is_windows,isabspath,isapprox,isascii,isassigned,isbits,isblockdev,ischardev,isconcrete,isconst,isdiag,isdir,isdirpath,isempty,isequal,iseven,isfifo,isfile,isfinite,ishermitian,isimag,isimmutable,isinf,isinteger,isinteractive,isleaftype,isless,isletter,islink,islocked,ismarked,ismatch,ismissing,ismount,isnan,isodd,isone,isopen,ispath,isperm,isposdef,isposdef!,ispow2,isqrt,isreadable,isreadonly,isready,isreal,issetgid,issetuid,issocket,issorted,issparse,issticky,issubnormal,issubset,issubtype,issymmetric,istaskdone,istaskstarted,istextmime,istril,istriu,isvalid,iswritable,iszero,join,joinpath,keys,keytype,kill,kron,last,lbeta,lcm,ldexp,ldltfact,ldltfact!,leading_ones,leading_zeros,length,less,lexcmp,lexless,lfact,lgamma,lgamma_fast,linearindices,linreg,linspace,listen,listenany,lock,log,log10,log10_fast,log1p,log1p_fast,log2,log2_fast,log_fast,logabsdet,logdet,logging,logm,logspace,lpad,lq,lqfact,lqfact!,lstat,lstrip,ltoh,lu,lufact,lufact!,lyap,macroexpand,map,map!,mapfoldl,mapfoldr,mapreduce,mapreducedim,mapslices,mark,match,matchall,max,max_fast,maxabs,maximum,maximum!,maxintfloat,mean,mean!,median,median!,merge,merge!,method_exists,methods,methodswith,middle,midpoints,mimewritable,min,min_fast,minabs,minimum,minimum!,minmax,minmax_fast,missing,mkdir,mkpath,mktemp,mktempdir,mod,mod1,mod2pi,modf,module_name,module_parent,mtime,muladd,mv,names,nb_available,ncodeunits,ndigits,ndims,next,nextfloat,nextind,nextpow,nextpow2,nextprod,nnz,nonzeros,norm,normalize,normalize!,normpath,notify,ntoh,ntuple,nullspace,num,num2hex,numerator,nzrange,object_id,occursin,oct,oftype,one,ones,oneunit,open,operm,ordschur,ordschur!,pairs,parent,parentindexes,parentindices,parse,partialsort,partialsort!,partialsortperm,partialsortperm!,peakflops,permute,permute!,permutedims,permutedims!,pi,pinv,pipeline,pointer,pointer_from_objref,pop!,popdisplay,popfirst!,position,pow_fast,powermod,precision,precompile,prepend!,prevfloat,prevind,prevpow,prevpow2,print,print_shortest,print_with_color,println,process_exited,process_running,prod,prod!,produce,promote,promote_rule,promote_shape,promote_type,push!,pushdisplay,pushfirst!,put!,pwd,qr,qrfact,qrfact!,quantile,quantile!,quit,rad2deg,rand,rand!,randcycle,randcycle!,randexp,randexp!,randjump,randn,randn!,randperm,randperm!,randstring,randsubseq,randsubseq!,range,rank,rationalize,read,read!,readandwrite,readavailable,readbytes!,readchomp,readdir,readline,readlines,readlink,readstring,readuntil,real,realmax,realmin,realpath,recv,recvfrom,redirect_stderr,redirect_stdin,redirect_stdout,redisplay,reduce,reducedim,reenable_sigint,reim,reinterpret,reload,relpath,rem,rem2pi,repeat,replace,replace!,repmat,repr,reprmime,reset,reshape,resize!,rethrow,retry,reverse,reverse!,reverseind,rm,rol,rol!,ror,ror!,rot180,rotl90,rotr90,round,rounding,rowvals,rpad,rsearch,rsearchindex,rsplit,rstrip,run,scale!,schedule,schur,schurfact,schurfact!,search,searchindex,searchsorted,searchsortedfirst,searchsortedlast,sec,secd,sech,seek,seekend,seekstart,select,select!,selectperm,selectperm!,send,serialize,set_zero_subnormals,setdiff,setdiff!,setenv,setindex!,setprecision,setrounding,shift!,show,showall,showcompact,showerror,shuffle,shuffle!,sign,signbit,signed,signif,significand,similar,sin,sin_fast,sinc,sincos,sind,sinh,sinh_fast,sinpi,size,sizehint!,sizeof,skip,skipchars,skipmissing,sleep,slicedim,sort,sort!,sortcols,sortperm,sortperm!,sortrows,sparse,sparsevec,spawn,spdiagm,speye,splice!,split,splitdir,splitdrive,splitext,spones,sprand,sprandn,sprint,spzeros,sqrt,sqrt_fast,sqrtm,squeeze,srand,stacktrace,start,startswith,stat,std,stdm,step,stride,strides,string,stringmime,strip,strwidth,sub2ind,subtypes,success,sum,sum!,sumabs,sumabs2,summary,supertype,svd,svdfact,svdfact!,svdvals,svdvals!,sylvester,symdiff,symdiff!,symlink,systemerror,take!,takebuf_array,takebuf_string,tan,tan_fast,tand,tanh,tanh_fast,task_local_storage,tempdir,tempname,thisind,tic,time,time_ns,timedwait,to_indices,toc,toq,touch,trace,trailing_ones,trailing_zeros,transcode,transpose,transpose!,tril,tril!,triu,triu!,trues,trunc,truncate,trylock,tryparse,typeintersect,typejoin,typemax,typemin,unescape_string,union,union!,unique,unique!,unlock,unmark,unsafe_copy!,unsafe_copyto!,unsafe_load,unsafe_pointer_to_objref,unsafe_read,unsafe_store!,unsafe_string,unsafe_trunc,unsafe_wrap,unsafe_write,unshift!,unsigned,uperm,valtype,values,var,varinfo,varm,vcat,vec,vecdot,vecnorm,versioninfo,view,wait,walkdir,warn,which,whos,widemul,widen,withenv,workspace,write,xor,yield,yieldto,zero,zeros,zip,applicable,eval,fieldtype,getfield,invoke,isa,isdefined,nfields,nothing,setfield!,throw,tuple,typeassert,typeof,uninitialized,undef},%
	% module functions
	keywords=[3]{asum,axpby!,axpy!,blascopy!,dot,dotc,dotu,gbmv,gbmv!,gemm,gemm!,gemv,gemv!,ger!,hemm,hemm!,hemv,hemv!,her!,her2k,her2k!,herk,herk!,iamax,nrm2,sbmv,sbmv!,scal,scal!,symm,symm!,symv,symv!,syr!,syr2k,syr2k!,syrk,syrk!,trmm,trmm!,trmv,trmv!,trsm,trsm!,trsv,trsv!),abs,abs2,abspath,accept,accumulate,accumulate!,acos,acos_fast,acosd,acosh,acosh_fast,acot,acotd,acoth,acsc,acscd,acsch,adjoint,adjoint!,all,all!,allunique,angle,angle_fast,any,any!,append!,apropos,argmax,argmin,ascii,asec,asecd,asech,asin,asin_fast,asind,asinh,asinh_fast,assert,asyncmap,asyncmap!,atan,atan2,atan2_fast,atan_fast,atand,atanh,atanh_fast,atexit,atreplinit,axes,backtrace,base,basename,beta,bfft,bfft!,big,bin,bind,binomial,bitbroadcast,bitrand,bits,bitstring,bkfact,bkfact!,blkdiag,brfft,broadcast,broadcast!,broadcast_getindex,broadcast_setindex!,bswap,bytes2hex,cat,catch_backtrace,catch_stacktrace,cbrt,cbrt_fast,cd,ceil,cfunction,cglobal,charwidth,checkbounds,checkindex,chmod,chol,cholfact,cholfact!,chomp,chop,chown,chr2ind,circcopy!,circshift,circshift!,cis,cis_fast,clamp,clamp!,cld,clipboard,close,cmp,coalesce,code_llvm,code_lowered,code_native,code_typed,code_warntype,codeunit,codeunits,collect,colon,complex,cond,condskeel,conj,conj!,connect,consume,contains,conv,conv2,convert,copy,copy!,copysign,copyto!,cor,cos,cos_fast,cosc,cosd,cosh,cosh_fast,cospi,cot,cotd,coth,count,count_ones,count_zeros,countlines,countnz,cov,cp,cross,csc,cscd,csch,ctime,ctranspose,ctranspose!,cummax,cummin,cumprod,cumprod!,cumsum,cumsum!,current_module,current_task,dct,dct!,dec,deconv,deepcopy,deg2rad,delete!,deleteat!,den,denominator,deserialize,det,detach,diag,diagind,diagm,diff,digits,digits!,dirname,disable_sigint,display,displayable,displaysize,div,divrem,done,dot,download,dropzeros,dropzeros!,dump,eachcol,eachindex,eachline,eachmatch,edit,eig,eigfact,eigfact!,eigmax,eigmin,eigvals,eigvals!,eigvecs,eltype,empty,empty!,endof,endswith,enumerate,eof,eps,equalto,error,esc,escape_string,evalfile,exit,exp,exp10,exp10_fast,exp2,exp2_fast,exp_fast,expand,expanduser,expm,expm!,expm1,expm1_fast,exponent,extrema,eye,factorial,factorize,falses,fd,fdio,fetch,fft,fft!,fftshift,fieldcount,fieldname,fieldnames,fieldoffset,filemode,filesize,fill,fill!,filt,filt!,filter,filter!,finalize,finalizer,find,findfirst,findin,findlast,findmax,findmax!,findmin,findmin!,findn,findnext,findnz,findprev,first,fld,fld1,fldmod,fldmod1,flipbits!,flipdim,flipsign,float,floor,flush,fma,foldl,foldr,foreach,frexp,full,fullname,functionloc,gamma,gc,gc_enable,gcd,gcdx,gensym,get,get!,get_zero_subnormals,getaddrinfo,getalladdrinfo,gethostname,getindex,getipaddr,getkey,getnameinfo,getpeername,getpid,getsockname,givens,gperm,gradient,hash,haskey,hcat,hessfact,hessfact!,hex,hex2bytes,hex2bytes!,hex2num,homedir,htol,hton,hvcat,hypot,hypot_fast,idct,idct!,identity,ifelse,ifft,ifft!,ifftshift,ignorestatus,im,imag,in,include_dependency,include_string,ind2chr,ind2sub,indexin,indices,indmax,indmin,info,insert!,instances,intersect,intersect!,inv,invmod,invperm,invpermute!,ipermute!,ipermutedims,irfft,is,is_apple,is_bsd,is_linux,is_unix,is_windows,isabspath,isapprox,isascii,isassigned,isbits,isblockdev,ischardev,isconcrete,isconst,isdiag,isdir,isdirpath,isempty,isequal,iseven,isfifo,isfile,isfinite,ishermitian,isimag,isimmutable,isinf,isinteger,isinteractive,isleaftype,isless,isletter,islink,islocked,ismarked,ismatch,ismissing,ismount,isnan,isodd,isone,isopen,ispath,isperm,isposdef,isposdef!,ispow2,isqrt,isreadable,isreadonly,isready,isreal,issetgid,issetuid,issocket,issorted,issparse,issticky,issubnormal,issubset,issubtype,issymmetric,istaskdone,istaskstarted,istextmime,istril,istriu,isvalid,iswritable,iszero,join,joinpath,keys,keytype,kill,kron,last,lbeta,lcm,ldexp,ldltfact,ldltfact!,leading_ones,leading_zeros,length,less,lexcmp,lexless,lfact,lgamma,lgamma_fast,linearindices,linreg,linspace,listen,listenany,lock,log,log10,log10_fast,log1p,log1p_fast,log2,log2_fast,log_fast,logabsdet,logdet,logging,logm,logspace,lpad,lq,lqfact,lqfact!,lstat,lstrip,ltoh,lu,lufact,lufact!,lyap,macroexpand,map,map!,mapfoldl,mapfoldr,mapreduce,mapreducedim,mapslices,mark,match,matchall,max,max_fast,maxabs,maximum,maximum!,maxintfloat,mean,mean!,median,median!,merge,merge!,method_exists,methods,methodswith,middle,midpoints,mimewritable,min,min_fast,minabs,minimum,minimum!,minmax,minmax_fast,missing,mkdir,mkpath,mktemp,mktempdir,mod,mod1,mod2pi,modf,module_name,module_parent,mtime,muladd,mv,names,nb_available,ncodeunits,ndigits,ndims,next,nextfloat,nextind,nextpow,nextpow2,nextprod,nnz,nonzeros,norm,normalize,normalize!,normpath,notify,ntoh,ntuple,nullspace,num,num2hex,numerator,nzrange,object_id,occursin,oct,oftype,one,ones,oneunit,open,operm,ordschur,ordschur!,pairs,parent,parentindexes,parentindices,parse,partialsort,partialsort!,partialsortperm,partialsortperm!,peakflops,permute,permute!,permutedims,permutedims!,pi,pinv,pipeline,plan_bfft,plan_bfft!,plan_brfft,plan_dct,plan_dct!,plan_fft,plan_fft!,plan_idct,plan_idct!,plan_ifft,plan_ifft!,plan_irfft,plan_rfft,pointer,pointer_from_objref,pop!,popdisplay,popfirst!,position,pow_fast,powermod,precision,precompile,prepend!,prevfloat,prevind,prevpow,prevpow2,print,print_shortest,print_with_color,println,process_exited,process_running,prod,prod!,produce,promote,promote_rule,promote_shape,promote_type,push!,pushdisplay,pushfirst!,put!,pwd,qr,qrfact,qrfact!,quantile,quantile!,quit,rad2deg,rand,rand!,randcycle,randcycle!,randexp,randexp!,randjump,randn,randn!,randperm,randperm!,randstring,randsubseq,randsubseq!,range,rank,rationalize,read,read!,readandwrite,readavailable,readbytes!,readchomp,readdir,readline,readlines,readlink,readstring,readuntil,real,realmax,realmin,realpath,recv,recvfrom,redirect_stderr,redirect_stdin,redirect_stdout,redisplay,reduce,reducedim,reenable_sigint,reim,reinterpret,reload,relpath,rem,rem2pi,repeat,replace,replace!,repmat,repr,reprmime,reset,reshape,resize!,rethrow,retry,reverse,reverse!,reverseind,rfft,rm,rol,rol!,ror,ror!,rot180,rotl90,rotr90,round,rounding,rowvals,rpad,rsearch,rsearchindex,rsplit,rstrip,run,scale!,schedule,schur,schurfact,schurfact!,search,searchindex,searchsorted,searchsortedfirst,searchsortedlast,sec,secd,sech,seek,seekend,seekstart,select,select!,selectperm,selectperm!,send,serialize,set_zero_subnormals,setdiff,setdiff!,setenv,setindex!,setprecision,setrounding,shift!,show,showall,showcompact,showerror,shuffle,shuffle!,sign,signbit,signed,signif,significand,similar,sin,sin_fast,sinc,sincos,sind,sinh,sinh_fast,sinpi,size,sizehint!,sizeof,skip,skipchars,skipmissing,sleep,slicedim,sort,sort!,sortcols,sortperm,sortperm!,sortrows,sparse,sparsevec,spawn,spdiagm,speye,splice!,split,splitdir,splitdrive,splitext,spones,sprand,sprandn,sprint,spzeros,sqrt,sqrt_fast,sqrtm,squeeze,srand,stacktrace,start,startswith,stat,std,stdm,step,stride,strides,string,stringmime,strip,strwidth,sub2ind,subtypes,success,sum,sum!,sumabs,sumabs2,summary,super,supertype,svd,svdfact,svdfact!,svdvals,svdvals!,sylvester,symdiff,symdiff!,symlink,systemerror,take!,takebuf_array,takebuf_string,tan,tan_fast,tand,tanh,tanh_fast,task_local_storage,tempdir,tempname,thisind,tic,time,time_ns,timedwait,to_indices,toc,toq,touch,trace,trailing_ones,trailing_zeros,transcode,transpose,transpose!,tril,tril!,triu,triu!,trues,trunc,truncate,trylock,tryparse,typeintersect,typejoin,typemax,typemin,unescape_string,union,union!,unique,unique!,unlock,unmark,unsafe_copy!,unsafe_copyto!,unsafe_load,unsafe_pointer_to_objref,unsafe_read,unsafe_store!,unsafe_string,unsafe_trunc,unsafe_wrap,unsafe_write,unshift!,unsigned,uperm,valtype,values,var,varinfo,varm,vcat,vec,vecdot,vecnorm,versioninfo,view,wait,walkdir,warn,which,whos,widemul,widen,withenv,workspace,write,xcorr,xor,yield,yieldto,zero,zeros,zip,broadcast_getindex,broadcast_indices,broadcast_setindex!,broadcast_similar,dotview,apropos,doc,countfrom,cycle,drop,enumerate,flatten,partition,product,repeated,rest,take,zip,get_creds!,with,calloc,errno,flush_cstdio,free,gethostname,getpid,malloc,realloc,strerror,strftime,strptime,systemsleep,time,transcode,dlclose,dlext,dllist,dlopen,dlopen_e,dlpath,dlsym,dlsym_e,find_library,adjoint,adjoint!,axpby!,axpy!,bkfact,bkfact!,chol,cholfact,cholfact!,cond,condskeel,copy_transpose!,copyto!,cross,det,diag,diagind,diagm,diff,dot,eig,eigfact,eigfact!,eigmax,eigmin,eigvals,eigvals!,eigvecs,factorize,getq,givens,gradient,hessfact,hessfact!,isdiag,ishermitian,isposdef,isposdef!,issuccess,issymmetric,istril,istriu,kron,ldltfact,ldltfact!,linreg,logabsdet,logdet,lq,lqfact,lqfact!,lu,lufact,lufact!,lyap,norm,normalize,normalize!,nullspace,ordschur,ordschur!,peakflops,pinv,qr,qrfact,qrfact!,rank,scale!,schur,schurfact,schurfact!,svd,svdfact,svdfact!,svdvals,svdvals!,sylvester,trace,transpose,transpose!,transpose_type,tril,tril!,triu,triu!,vecdot,vecnorm,html,latex,license,readme,isexpr,quot,show_sexpr,add,available,build,checkout,clone,dir,free,init,installed,pin,resolve,rm,setprotocol!,status,test,update,deserialize,serialize,blkdiag,droptol!,dropzeros,dropzeros!,issparse,nnz,nonzeros,nzrange,permute,rowvals,sparse,sparsevec,spdiagm,spones,sprand,sprandn,spzeros,catch_stacktrace,stacktrace,cpu_info,cpu_summary,free_memory,isapple,isbsd,islinux,isunix,iswindows,loadavg,total_memory,uptime,atomic_add!,atomic_and!,atomic_cas!,atomic_fence,atomic_max!,atomic_min!,atomic_nand!,atomic_or!,atomic_sub!,atomic_xchg!,atomic_xor!,nthreads,threadid,applicable,eval,fieldtype,getfield,invoke,isa,isdefined,nfields,nothing,setfield!,throw,tuple,typeassert,typeof,uninitialized,undef},%
	% types and modules
	keywords=[2]{AbstractArray,AbstractChannel,AbstractDict,AbstractDisplay,AbstractFloat,AbstractIrrational,AbstractMatrix,AbstractRNG,AbstractRange,AbstractSerializer,AbstractSet,AbstractSparseArray,AbstractSparseMatrix,AbstractSparseVector,AbstractString,AbstractUnitRange,AbstractVecOrMat,AbstractVector,Adjoint,Any,ArgumentError,Array,AssertionError,Bidiagonal,BigFloat,BigInt,BitArray,BitMatrix,BitSet,BitVector,Bool,BoundsError,BufferStream,CapturedException,CartesianIndex,CartesianIndices,Cchar,Cdouble,Cfloat,Channel,Char,Cint,Cintmax_t,Clong,Clonglong,Cmd,CodeInfo,Colon,Complex,ComplexF16,ComplexF32,ComplexF64,CompositeException,Condition,ConjArray,ConjMatrix,ConjVector,Cptrdiff_t,Cshort,Csize_t,Cssize_t,Cstring,Cuchar,Cuint,Cuintmax_t,Culong,Culonglong,Cushort,Cvoid,Cwchar_t,Cwstring,DataType,DenseArray,DenseMatrix,DenseVecOrMat,DenseVector,Diagonal,Dict,DimensionMismatch,Dims,DivideError,DomainError,EOFError,EachLine,Enum,Enumerate,ErrorException,Exception,ExponentialBackOff,Expr,Factorization,Float16,Float32,Float64,Function,GlobalRef,GotoNode,HTML,Hermitian,IO,IOBuffer,IOContext,IOStream,IPAddr,IPv4,IPv6,IndexCartesian,IndexLinear,IndexStyle,InexactError,InitError,Int,Int128,Int16,Int32,Int64,Int8,Integer,InterruptException,InvalidStateException,Irrational,KeyError,LabelNode,LinSpace,LineNumberNode,LinearIndices,LoadError,LowerTriangular,MIME,Matrix,MersenneTwister,Method,MethodError,MethodTable,Missing,MissingException,Module,NTuple,NamedTuple,NewvarNode,Nothing,Number,ObjectIdDict,OrdinalRange,OutOfMemoryError,OverflowError,Pair,PartialQuickSort,PermutedDimsArray,Pipe,Ptr,QuoteNode,RandomDevice,Rational,RawFD,ReadOnlyMemoryError,Real,ReentrantLock,Ref,Regex,RegexMatch,RoundingMode,RowVector,SSAValue,SegmentationFault,SerializationState,Set,Signed,SimpleVector,Slot,SlotNumber,Some,SparseMatrixCSC,SparseVector,StackFrame,StackOverflowError,StackTrace,StepRange,StepRangeLen,StridedArray,StridedMatrix,StridedVecOrMat,StridedVector,String,StringIndexError,SubArray,SubString,SymTridiagonal,Symbol,Symmetric,SystemError,TCPSocket,Task,Text,TextDisplay,Timer,Transpose,Tridiagonal,Tuple,Type,TypeError,TypeMapEntry,TypeMapLevel,TypeName,TypeVar,TypedSlot,UDPSocket,UInt,UInt128,UInt16,UInt32,UInt64,UInt8,UndefRefError,UndefVarError,UniformScaling,Uninitialized,Union,UnionAll,UnitRange,Unsigned,UpperTriangular,Val,Vararg,VecElement,VecOrMat,Vector,VersionNumber,WeakKeyDict,WeakRef,BLAS,Base,Broadcast,DFT,Docs,Iterators,LAPACK,LibGit2,Libc,Libdl,LinAlg,Markdown,Meta,Operators,Pkg,Serializer,SparseArrays,StackTraces,Sys,Threads,Core,Main},%
	% literals
	keywords=[1]{true,false,nothing,missing,im,uninitialized,NaN,NaN16,NaN32,NaN64,Inf,Inf16,Inf32,Inf64,ARGS,C_NULL,ENDIAN_BOM,ENV,LOAD_PATH,PROGRAM_FILE,STDERR,STDIN,STDOUT,VERSION},
	% keywords
	keywords=[1]{mutable,immutable,struct,begin,end,function,macro,quote,let,local,global,const,abstract,module,baremodule,using,import,export,in,if,else,elseif,for,while,do,try,type,catch,finally,return,break,continue},%
	sensitive=true,
	morecomment=[l]{\#},
	morecomment=[n]{\#=}{=\#},
	morestring=[s]{"}{"},
	morestring=[m]{'}{'},
	literate=*{-}{-}1,
	alsoletter=!?
}

\lstdefinestyle{julia}{
	backgroundcolor  = \color[HTML]{F2F2F2},
	basicstyle       = \JuliaMonoRegular\small\color[HTML]{19177C},
	numberstyle      = \JuliaMonoRegular\scriptsize\color[HTML]{7F7F7F},
	keywordstyle     = [1]{\JuliaMonoBold\color[HTML]{1BA1EA}},
	keywordstyle     = [2]{\color[HTML]{0F6FA3}},
	keywordstyle     = [3]{\color[HTML]{0000FF}},
	stringstyle      = \JuliaMonoRegular\color[HTML]{F5615C},
	commentstyle     = \color[HTML]{AAAAAA},
	rulecolor        = \color[HTML]{000000},
	frame=lines,
	xleftmargin=5pt,
	framexleftmargin=25pt,
	framextopmargin=4pt,
	framexbottommargin=4pt,
	tabsize=4,
	captionpos=b,
	breaklines=true,
	breakatwhitespace=false,
	showstringspaces=false,
	showspaces=false,
	showtabs=false,
	columns=fullflexible,
	keepspaces=true,
	% numbers=left
}

    """
    julialistingsunicode = """
% set lstlisting to accept full Julia unicode support
\makeatletter
\lst@InputCatcodes
\def\lst@DefEC{%
 \lst@CCECUse \lst@ProcessLetter
  % 2-digit hex
  ^^a1% ¡   \exclamdown Inverted Exclamation Mark
  ^^a3% £   \sterling   Pound Sign
  ^^a5% ¥   \yen    Yen Sign
  ^^a6% ¦   \brokenbar  Broken Bar / Broken Vertical Bar
  ^^a7% §   \S  Section Sign
  ^^a9% ©   \copyright, \:copyright:    Copyright Sign
  ^^aa% ª   \ordfeminine    Feminine Ordinal Indicator
  ^^ac% ¬   \neg    Not Sign
  ^^ae% ®   \circledR, \:registered:    Registered Sign / Registered Trade Mark Sign
  ^^af% ¯   \highminus  Macron / Spacing Macron
  ^^b0% °   \degree Degree Sign
  ^^b1% ±   \pm Plus-Minus Sign / Plus-Or-Minus Sign
  ^^b2% ²   \^2 Superscript Two / Superscript Digit Two
  ^^b3% ³   \^3 Superscript Three / Superscript Digit Three
  ^^b6% ¶   \P  Pilcrow Sign / Paragraph Sign
  ^^b7% ·   \cdotp  Middle Dot
  ^^b9% ¹   \^1 Superscript One / Superscript Digit One
  ^^ba% º   \ordmasculine   Masculine Ordinal Indicator
  ^^bc% ¼   \1/4    Vulgar Fraction One Quarter / Fraction One Quarter
  ^^bd% ½   \1/2    Vulgar Fraction One Half / Fraction One Half
  ^^be% ¾   \3/4    Vulgar Fraction Three Quarters / Fraction Three Quarters
  ^^bf% ¿   \questiondown   Inverted Question Mark
  ^^c5% Å   \AA Latin Capital Letter A With Ring Above / Latin Capital Letter A Ring
  ^^c6% Æ   \AE Latin Capital Letter Ae / Latin Capital Letter A E
  ^^d0% Ð   \DH Latin Capital Letter Eth
  ^^d7% ×   \times  Multiplication Sign
  ^^d8% Ø   \O  Latin Capital Letter O With Stroke / Latin Capital Letter O Slash
  ^^de% Þ   \TH Latin Capital Letter Thorn
  ^^df% ß   \ss Latin Small Letter Sharp S
  ^^e5% å   \aa Latin Small Letter A With Ring Above / Latin Small Letter A Ring
  ^^e6% æ   \ae Latin Small Letter Ae / Latin Small Letter A E
  ^^f0% ð   \eth, \dh   Latin Small Letter Eth
  ^^f7% ÷   \div    Division Sign
  ^^f8% ø   \o  Latin Small Letter O With Stroke / Latin Small Letter O Slash
  ^^fe% þ   \th Latin Small Letter Thorn
  % zero-padded 4-digit hex
  ^^^^0110% Đ   \DJ Latin Capital Letter D With Stroke / Latin Capital Letter D Bar
  ^^^^0111% đ   \dj Latin Small Letter D With Stroke / Latin Small Letter D Bar
  ^^^^0127% ħ   \hbar   Latin Small Letter H With Stroke / Latin Small Letter H Bar
  ^^^^0131% ı   \imath  Latin Small Letter Dotless I
  ^^^^0141% Ł   \L  Latin Capital Letter L With Stroke / Latin Capital Letter L Slash
  ^^^^0142% ł   \l  Latin Small Letter L With Stroke / Latin Small Letter L Slash
  ^^^^014a% Ŋ   \NG Latin Capital Letter Eng
  ^^^^014b% ŋ   \ng Latin Small Letter Eng
  ^^^^0152% Œ   \OE Latin Capital Ligature Oe / Latin Capital Letter O E
  ^^^^0153% œ   \oe Latin Small Ligature Oe / Latin Small Letter O E
  ^^^^0195% ƕ   \hvlig  Latin Small Letter Hv / Latin Small Letter H V
  ^^^^019e% ƞ   \nrleg  Latin Small Letter N With Long Right Leg
  ^^^^01b5% Ƶ   \Zbar   Latin Capital Letter Z With Stroke / Latin Capital Letter Z Bar
  ^^^^01c2% ǂ   \doublepipe Latin Letter Alveolar Click / Latin Letter Pipe Double Bar
  ^^^^0237% ȷ   \jmath  Latin Small Letter Dotless J
  ^^^^0250% ɐ   \trna   Latin Small Letter Turned A
  ^^^^0252% ɒ   \trnsa  Latin Small Letter Turned Alpha / Latin Small Letter Turned Script A
  ^^^^0254% ɔ   \openo  Latin Small Letter Open O
  ^^^^0256% ɖ   \rtld   Latin Small Letter D With Tail / Latin Small Letter D Retroflex Hook
  ^^^^0259% ə   \schwa  Latin Small Letter Schwa
  ^^^^0263% ɣ   \pgamma Latin Small Letter Gamma
  ^^^^0264% ɤ   \pbgam  Latin Small Letter Rams Horn / Latin Small Letter Baby Gamma
  ^^^^0265% ɥ   \trnh   Latin Small Letter Turned H
  ^^^^026c% ɬ   \btdl   Latin Small Letter L With Belt / Latin Small Letter L Belt
  ^^^^026d% ɭ   \rtll   Latin Small Letter L With Retroflex Hook / Latin Small Letter L Retroflex Hook
  ^^^^026f% ɯ   \trnm   Latin Small Letter Turned M
  ^^^^0270% ɰ   \trnmlr Latin Small Letter Turned M With Long Leg
  ^^^^0271% ɱ   \ltlmr  Latin Small Letter M With Hook / Latin Small Letter M Hook
  ^^^^0272% ɲ   \ltln   Latin Small Letter N With Left Hook / Latin Small Letter N Hook
  ^^^^0273% ɳ   \rtln   Latin Small Letter N With Retroflex Hook / Latin Small Letter N Retroflex Hook
  ^^^^0277% ɷ   \clomeg Latin Small Letter Closed Omega
  ^^^^0278% ɸ   \ltphi  Latin Small Letter Phi
  ^^^^0279% ɹ   \trnr   Latin Small Letter Turned R
  ^^^^027a% ɺ   \trnrl  Latin Small Letter Turned R With Long Leg
  ^^^^027b% ɻ   \rttrnr Latin Small Letter Turned R With Hook / Latin Small Letter Turned R Hook
  ^^^^027c% ɼ   \rl Latin Small Letter R With Long Leg
  ^^^^027d% ɽ   \rtlr   Latin Small Letter R With Tail / Latin Small Letter R Hook
  ^^^^027e% ɾ   \fhr    Latin Small Letter R With Fishhook / Latin Small Letter Fishhook R
  ^^^^0282% ʂ   \rtls   Latin Small Letter S With Hook / Latin Small Letter S Hook
  ^^^^0283% ʃ   \esh    Latin Small Letter Esh
  ^^^^0287% ʇ   \trnt   Latin Small Letter Turned T
  ^^^^0288% ʈ   \rtlt   Latin Small Letter T With Retroflex Hook / Latin Small Letter T Retroflex Hook
  ^^^^028a% ʊ   \pupsil Latin Small Letter Upsilon
  ^^^^028b% ʋ   \pscrv  Latin Small Letter V With Hook / Latin Small Letter Script V
  ^^^^028c% ʌ   \invv   Latin Small Letter Turned V
  ^^^^028d% ʍ   \invw   Latin Small Letter Turned W
  ^^^^028e% ʎ   \trny   Latin Small Letter Turned Y
  ^^^^0290% ʐ   \rtlz   Latin Small Letter Z With Retroflex Hook / Latin Small Letter Z Retroflex Hook
  ^^^^0292% ʒ   \yogh   Latin Small Letter Ezh / Latin Small Letter Yogh
  ^^^^0294% ʔ   \glst   Latin Letter Glottal Stop
  ^^^^0295% ʕ   \reglst Latin Letter Pharyngeal Voiced Fricative / Latin Letter Reversed Glottal Stop
  ^^^^0296% ʖ   \inglst Latin Letter Inverted Glottal Stop
  ^^^^029e% ʞ   \turnk  Latin Small Letter Turned K
  ^^^^02a4% ʤ   \dyogh  Latin Small Letter Dezh Digraph / Latin Small Letter D Yogh
  ^^^^02a7% ʧ   \tesh   Latin Small Letter Tesh Digraph / Latin Small Letter T Esh
  ^^^^02b0% ʰ   \^h Modifier Letter Small H
  ^^^^02b2% ʲ   \^j Modifier Letter Small J
  ^^^^02b3% ʳ   \^r Modifier Letter Small R
  ^^^^02b7% ʷ   \^w Modifier Letter Small W
  ^^^^02b8% ʸ   \^y Modifier Letter Small Y
  ^^^^02bc% ʼ   \rasp   Modifier Letter Apostrophe
  ^^^^02c8% ˈ   \verts  Modifier Letter Vertical Line
  ^^^^02cc% ˌ   \verti  Modifier Letter Low Vertical Line
  ^^^^02d0% ː   \lmrk   Modifier Letter Triangular Colon
  ^^^^02d1% ˑ   \hlmrk  Modifier Letter Half Triangular Colon
  ^^^^02d2% ˒   \sbrhr  Modifier Letter Centred Right Half Ring / Modifier Letter Centered Right Half Ring
  ^^^^02d3% ˓   \sblhr  Modifier Letter Centred Left Half Ring / Modifier Letter Centered Left Half Ring
  ^^^^02d4% ˔   \rais   Modifier Letter Up Tack
  ^^^^02d5% ˕   \low    Modifier Letter Down Tack
  ^^^^02d8% ˘   \u  Breve / Spacing Breve
  ^^^^02dc% ˜   \tildelow   Small Tilde / Spacing Tilde
  ^^^^02e1% ˡ   \^l Modifier Letter Small L
  ^^^^02e2% ˢ   \^s Modifier Letter Small S
  ^^^^02e3% ˣ   \^x Modifier Letter Small X
  ^^^^0300%  ̀  \grave  Combining Grave Accent / Non-Spacing Grave
  ^^^^0301%  ́  \acute  Combining Acute Accent / Non-Spacing Acute
  ^^^^0302%  ̂  \hat    Combining Circumflex Accent / Non-Spacing Circumflex
  ^^^^0303%  ̃  \tilde  Combining Tilde / Non-Spacing Tilde
  ^^^^0304%  ̄  \bar    Combining Macron / Non-Spacing Macron
  ^^^^0305%  ̅  \overbar    Combining Overline / Non-Spacing Overscore
  ^^^^0306%  ̆  \breve  Combining Breve / Non-Spacing Breve
  ^^^^0307%  ̇  \dot    Combining Dot Above / Non-Spacing Dot Above
  ^^^^0308%  ̈  \ddot   Combining Diaeresis / Non-Spacing Diaeresis
  ^^^^0309%  ̉  \ovhook Combining Hook Above / Non-Spacing Hook Above
  ^^^^030a%  ̊  \ocirc  Combining Ring Above / Non-Spacing Ring Above
  ^^^^030b%  ̋  \H  Combining Double Acute Accent / Non-Spacing Double Acute
  ^^^^030c%  ̌  \check  Combining Caron / Non-Spacing Hacek
  ^^^^0310%  ̐  \candra Combining Candrabindu / Non-Spacing Candrabindu
  ^^^^0312%  ̒  \oturnedcomma   Combining Turned Comma Above / Non-Spacing Turned Comma Above
  ^^^^0315%  ̕  \ocommatopright Combining Comma Above Right / Non-Spacing Comma Above Right
  ^^^^031a%  ̚  \droang Combining Left Angle Above / Non-Spacing Left Angle Above
  ^^^^0321%  ̡  \palh   Combining Palatalized Hook Below / Non-Spacing Palatalized Hook Below
  ^^^^0322%  ̢  \rh Combining Retroflex Hook Below / Non-Spacing Retroflex Hook Below
  ^^^^0327%  ̧  \c  Combining Cedilla / Non-Spacing Cedilla
  ^^^^0328%  ̨  \k  Combining Ogonek / Non-Spacing Ogonek
  ^^^^032a%  ̪  \sbbrg  Combining Bridge Below / Non-Spacing Bridge Below
  ^^^^0330%  ̰  \wideutilde Combining Tilde Below / Non-Spacing Tilde Below
  ^^^^0332%  ̲  \underbar   Combining Low Line / Non-Spacing Underscore
  ^^^^0336%  ̶  \strike, \sout  Combining Long Stroke Overlay / Non-Spacing Long Bar Overlay
  ^^^^0338%  ̸  \not    Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^034d%  ͍  \underleftrightarrow    Combining Left Right Arrow Below
  ^^^^0391% Α   \Alpha  Greek Capital Letter Alpha
  ^^^^0392% Β   \Beta   Greek Capital Letter Beta
  ^^^^0393% Γ   \Gamma  Greek Capital Letter Gamma
  ^^^^0394% Δ   \Delta  Greek Capital Letter Delta
  ^^^^0395% Ε   \Epsilon    Greek Capital Letter Epsilon
  ^^^^0396% Ζ   \Zeta   Greek Capital Letter Zeta
  ^^^^0397% Η   \Eta    Greek Capital Letter Eta
  ^^^^0398% Θ   \Theta  Greek Capital Letter Theta
  ^^^^0399% Ι   \Iota   Greek Capital Letter Iota
  ^^^^039a% Κ   \Kappa  Greek Capital Letter Kappa
  ^^^^039b% Λ   \Lambda Greek Capital Letter Lamda / Greek Capital Letter Lambda
  ^^^^039c% Μ   \upMu   Greek Capital Letter Mu
  ^^^^039d% Ν   \upNu   Greek Capital Letter Nu
  ^^^^039e% Ξ   \Xi Greek Capital Letter Xi
  ^^^^039f% Ο   \upOmicron  Greek Capital Letter Omicron
  ^^^^03a0% Π   \Pi Greek Capital Letter Pi
  ^^^^03a1% Ρ   \Rho    Greek Capital Letter Rho
  ^^^^03a3% Σ   \Sigma  Greek Capital Letter Sigma
  ^^^^03a4% Τ   \Tau    Greek Capital Letter Tau
  ^^^^03a5% Υ   \Upsilon    Greek Capital Letter Upsilon
  ^^^^03a6% Φ   \Phi    Greek Capital Letter Phi
  ^^^^03a7% Χ   \Chi    Greek Capital Letter Chi
  ^^^^03a8% Ψ   \Psi    Greek Capital Letter Psi
  ^^^^03a9% Ω   \Omega  Greek Capital Letter Omega
  ^^^^03b1% α   \alpha  Greek Small Letter Alpha
  ^^^^03b2% β   \beta   Greek Small Letter Beta
  ^^^^03b3% γ   \gamma  Greek Small Letter Gamma
  ^^^^03b4% δ   \delta  Greek Small Letter Delta
  ^^^^03b5% ε   \upepsilon, \varepsilon Greek Small Letter Epsilon
  ^^^^03b6% ζ   \zeta   Greek Small Letter Zeta
  ^^^^03b7% η   \eta    Greek Small Letter Eta
  ^^^^03b8% θ   \theta  Greek Small Letter Theta
  ^^^^03b9% ι   \iota   Greek Small Letter Iota
  ^^^^03ba% κ   \kappa  Greek Small Letter Kappa
  ^^^^03bb% λ   \lambda Greek Small Letter Lamda / Greek Small Letter Lambda
  ^^^^03bc% μ   \mu Greek Small Letter Mu
  ^^^^03bd% ν   \nu Greek Small Letter Nu
  ^^^^03be% ξ   \xi Greek Small Letter Xi
  ^^^^03bf% ο   \upomicron  Greek Small Letter Omicron
  ^^^^03c0% π   \pi Greek Small Letter Pi
  ^^^^03c1% ρ   \rho    Greek Small Letter Rho
  ^^^^03c2% ς   \varsigma   Greek Small Letter Final Sigma
  ^^^^03c3% σ   \sigma  Greek Small Letter Sigma
  ^^^^03c4% τ   \tau    Greek Small Letter Tau
  ^^^^03c5% υ   \upsilon    Greek Small Letter Upsilon
  ^^^^03c6% φ   \varphi Greek Small Letter Phi
  ^^^^03c7% χ   \chi    Greek Small Letter Chi
  ^^^^03c8% ψ   \psi    Greek Small Letter Psi
  ^^^^03c9% ω   \omega  Greek Small Letter Omega
  ^^^^03d0% ϐ   \upvarbeta  Greek Beta Symbol / Greek Small Letter Curled Beta
  ^^^^03d1% ϑ   \vartheta   Greek Theta Symbol / Greek Small Letter Script Theta
  ^^^^03d5% ϕ   \phi    Greek Phi Symbol / Greek Small Letter Script Phi
  ^^^^03d6% ϖ   \varpi  Greek Pi Symbol / Greek Small Letter Omega Pi
  ^^^^03d8% Ϙ   \upoldKoppa Greek Letter Archaic Koppa
  ^^^^03d9% ϙ   \upoldkoppa Greek Small Letter Archaic Koppa
  ^^^^03da% Ϛ   \Stigma Greek Letter Stigma / Greek Capital Letter Stigma
  ^^^^03db% ϛ   \upstigma   Greek Small Letter Stigma
  ^^^^03dc% Ϝ   \Digamma    Greek Letter Digamma / Greek Capital Letter Digamma
  ^^^^03dd% ϝ   \digamma    Greek Small Letter Digamma
  ^^^^03de% Ϟ   \Koppa  Greek Letter Koppa / Greek Capital Letter Koppa
  ^^^^03df% ϟ   \upkoppa    Greek Small Letter Koppa
  ^^^^03e0% Ϡ   \Sampi  Greek Letter Sampi / Greek Capital Letter Sampi
  ^^^^03e1% ϡ   \upsampi    Greek Small Letter Sampi
  ^^^^03f0% ϰ   \varkappa   Greek Kappa Symbol / Greek Small Letter Script Kappa
  ^^^^03f1% ϱ   \varrho Greek Rho Symbol / Greek Small Letter Tailed Rho
  ^^^^03f4% ϴ   \varTheta   Greek Capital Theta Symbol
  ^^^^03f5% ϵ   \epsilon    Greek Lunate Epsilon Symbol
  ^^^^03f6% ϶   \backepsilon    Greek Reversed Lunate Epsilon Symbol
  % 4-digit hex
  ^^^^1d2c% ᴬ   \^A Modifier Letter Capital A
  ^^^^1d2e% ᴮ   \^B Modifier Letter Capital B
  ^^^^1d30% ᴰ   \^D Modifier Letter Capital D
  ^^^^1d31% ᴱ   \^E Modifier Letter Capital E
  ^^^^1d33% ᴳ   \^G Modifier Letter Capital G
  ^^^^1d34% ᴴ   \^H Modifier Letter Capital H
  ^^^^1d35% ᴵ   \^I Modifier Letter Capital I
  ^^^^1d36% ᴶ   \^J Modifier Letter Capital J
  ^^^^1d37% ᴷ   \^K Modifier Letter Capital K
  ^^^^1d38% ᴸ   \^L Modifier Letter Capital L
  ^^^^1d39% ᴹ   \^M Modifier Letter Capital M
  ^^^^1d3a% ᴺ   \^N Modifier Letter Capital N
  ^^^^1d3c% ᴼ   \^O Modifier Letter Capital O
  ^^^^1d3e% ᴾ   \^P Modifier Letter Capital P
  ^^^^1d3f% ᴿ   \^R Modifier Letter Capital R
  ^^^^1d40% ᵀ   \^T Modifier Letter Capital T
  ^^^^1d41% ᵁ   \^U Modifier Letter Capital U
  ^^^^1d42% ᵂ   \^W Modifier Letter Capital W
  ^^^^1d43% ᵃ   \^a Modifier Letter Small A
  ^^^^1d45% ᵅ   \^alpha Modifier Letter Small Alpha
  ^^^^1d47% ᵇ   \^b Modifier Letter Small B
  ^^^^1d48% ᵈ   \^d Modifier Letter Small D
  ^^^^1d49% ᵉ   \^e Modifier Letter Small E
  ^^^^1d4b% ᵋ   \^epsilon   Modifier Letter Small Open E
  ^^^^1d4d% ᵍ   \^g Modifier Letter Small G
  ^^^^1d4f% ᵏ   \^k Modifier Letter Small K
  ^^^^1d50% ᵐ   \^m Modifier Letter Small M
  ^^^^1d52% ᵒ   \^o Modifier Letter Small O
  ^^^^1d56% ᵖ   \^p Modifier Letter Small P
  ^^^^1d57% ᵗ   \^t Modifier Letter Small T
  ^^^^1d58% ᵘ   \^u Modifier Letter Small U
  ^^^^1d5b% ᵛ   \^v Modifier Letter Small V
  ^^^^1d5d% ᵝ   \^beta  Modifier Letter Small Beta
  ^^^^1d5e% ᵞ   \^gamma Modifier Letter Small Greek Gamma
  ^^^^1d5f% ᵟ   \^delta Modifier Letter Small Delta
  ^^^^1d60% ᵠ   \^phi   Modifier Letter Small Greek Phi
  ^^^^1d61% ᵡ   \^chi   Modifier Letter Small Chi
  ^^^^1d62% ᵢ   \_i Latin Subscript Small Letter I
  ^^^^1d63% ᵣ   \_r Latin Subscript Small Letter R
  ^^^^1d64% ᵤ   \_u Latin Subscript Small Letter U
  ^^^^1d65% ᵥ   \_v Latin Subscript Small Letter V
  ^^^^1d66% ᵦ   \_beta  Greek Subscript Small Letter Beta
  ^^^^1d67% ᵧ   \_gamma Greek Subscript Small Letter Gamma
  ^^^^1d68% ᵨ   \_rho   Greek Subscript Small Letter Rho
  ^^^^1d69% ᵩ   \_phi   Greek Subscript Small Letter Phi
  ^^^^1d6a% ᵪ   \_chi   Greek Subscript Small Letter Chi
  ^^^^1d9c% ᶜ   \^c Modifier Letter Small C
  ^^^^1da0% ᶠ   \^f Modifier Letter Small F
  ^^^^1da5% ᶥ   \^iota  Modifier Letter Small Iota
  ^^^^1db2% ᶲ   \^Phi   Modifier Letter Small Phi
  ^^^^1dbb% ᶻ   \^z Modifier Letter Small Z
  ^^^^1dbf% ᶿ   \^theta Modifier Letter Small Theta
  ^^^^2002%     \enspace    En Space
  ^^^^2003%     \quad   Em Space
  ^^^^2005%     \thickspace Four-Per-Em Space
  ^^^^2009%     \thinspace  Thin Space
  ^^^^200a%     \hspace Hair Space
  ^^^^2013% –   \endash En Dash
  ^^^^2014% —   \emdash Em Dash
  ^^^^2016% ‖   \Vert   Double Vertical Line / Double Vertical Bar
  ^^^^2018% ‘   \lq Left Single Quotation Mark / Single Turned Comma Quotation Mark
  ^^^^2019% ’   \rq Right Single Quotation Mark / Single Comma Quotation Mark
  ^^^^201b% ‛   \reapos Single High-Reversed-9 Quotation Mark / Single Reversed Comma Quotation Mark
  ^^^^201c% “   \quotedblleft   Left Double Quotation Mark / Double Turned Comma Quotation Mark
  ^^^^201d% ”   \quotedblright  Right Double Quotation Mark / Double Comma Quotation Mark
  ^^^^2020% †   \dagger Dagger
  ^^^^2021% ‡   \ddagger    Double Dagger
  ^^^^2022% •   \bullet Bullet
  ^^^^2026% …   \dots, \ldots   Horizontal Ellipsis
  ^^^^2030% ‰   \perthousand    Per Mille Sign
  ^^^^2031% ‱   \pertenthousand Per Ten Thousand Sign
  ^^^^2032% ′   \prime  Prime
  ^^^^2033% ″   \pprime Double Prime
  ^^^^2034% ‴   \ppprime    Triple Prime
  ^^^^2035% ‵   \backprime  Reversed Prime
  ^^^^2036% ‶   \backpprime Reversed Double Prime
  ^^^^2037% ‷   \backppprime    Reversed Triple Prime
  ^^^^2039% ‹   \guilsinglleft  Single Left-Pointing Angle Quotation Mark / Left Pointing Single Guillemet
  ^^^^203a% ›   \guilsinglright Single Right-Pointing Angle Quotation Mark / Right Pointing Single Guillemet
  ^^^^203c% ‼   \:bangbang: Double Exclamation Mark
  ^^^^2040% ⁀   \tieconcat  Character Tie
  ^^^^2049% ⁉   \:interrobang:  Exclamation Question Mark
  ^^^^2057% ⁗   \pppprime   Quadruple Prime
  ^^^^205d% ⁝   \tricolon   Tricolon
  ^^^^2060% ⁠   \nolinebreak    Word Joiner
  ^^^^2070% ⁰   \^0 Superscript Zero / Superscript Digit Zero
  ^^^^2071% ⁱ   \^i Superscript Latin Small Letter I
  ^^^^2074% ⁴   \^4 Superscript Four / Superscript Digit Four
  ^^^^2075% ⁵   \^5 Superscript Five / Superscript Digit Five
  ^^^^2076% ⁶   \^6 Superscript Six / Superscript Digit Six
  ^^^^2077% ⁷   \^7 Superscript Seven / Superscript Digit Seven
  ^^^^2078% ⁸   \^8 Superscript Eight / Superscript Digit Eight
  ^^^^2079% ⁹   \^9 Superscript Nine / Superscript Digit Nine
  ^^^^207a% ⁺   \^+ Superscript Plus Sign
  ^^^^207b% ⁻   \^- Superscript Minus / Superscript Hyphen-Minus
  ^^^^207c% ⁼   \^= Superscript Equals Sign
  ^^^^207d% ⁽   \^( Superscript Left Parenthesis / Superscript Opening Parenthesis
  ^^^^207e% ⁾   \^) Superscript Right Parenthesis / Superscript Closing Parenthesis
  ^^^^207f% ⁿ   \^n Superscript Latin Small Letter N
  ^^^^2080% ₀   \_0 Subscript Zero / Subscript Digit Zero
  ^^^^2081% ₁   \_1 Subscript One / Subscript Digit One
  ^^^^2082% ₂   \_2 Subscript Two / Subscript Digit Two
  ^^^^2083% ₃   \_3 Subscript Three / Subscript Digit Three
  ^^^^2084% ₄   \_4 Subscript Four / Subscript Digit Four
  ^^^^2085% ₅   \_5 Subscript Five / Subscript Digit Five
  ^^^^2086% ₆   \_6 Subscript Six / Subscript Digit Six
  ^^^^2087% ₇   \_7 Subscript Seven / Subscript Digit Seven
  ^^^^2088% ₈   \_8 Subscript Eight / Subscript Digit Eight
  ^^^^2089% ₉   \_9 Subscript Nine / Subscript Digit Nine
  ^^^^208a% ₊   \_+ Subscript Plus Sign
  ^^^^208b% ₋   \_- Subscript Minus / Subscript Hyphen-Minus
  ^^^^208c% ₌   \_= Subscript Equals Sign
  ^^^^208d% ₍   \_( Subscript Left Parenthesis / Subscript Opening Parenthesis
  ^^^^208e% ₎   \_) Subscript Right Parenthesis / Subscript Closing Parenthesis
  ^^^^2090% ₐ   \_a Latin Subscript Small Letter A
  ^^^^2091% ₑ   \_e Latin Subscript Small Letter E
  ^^^^2092% ₒ   \_o Latin Subscript Small Letter O
  ^^^^2093% ₓ   \_x Latin Subscript Small Letter X
  ^^^^2094% ₔ   \_schwa Latin Subscript Small Letter Schwa
  ^^^^2095% ₕ   \_h Latin Subscript Small Letter H
  ^^^^2096% ₖ   \_k Latin Subscript Small Letter K
  ^^^^2097% ₗ   \_l Latin Subscript Small Letter L
  ^^^^2098% ₘ   \_m Latin Subscript Small Letter M
  ^^^^2099% ₙ   \_n Latin Subscript Small Letter N
  ^^^^209a% ₚ   \_p Latin Subscript Small Letter P
  ^^^^209b% ₛ   \_s Latin Subscript Small Letter S
  ^^^^209c% ₜ   \_t Latin Subscript Small Letter T
  ^^^^20a7% ₧   \pes    Peseta Sign
  ^^^^20ac% €   \euro   Euro Sign
  ^^^^20d0%  ⃐  \leftharpoonaccent  Combining Left Harpoon Above / Non-Spacing Left Harpoon Above
  ^^^^20d1%  ⃑  \rightharpoonaccent Combining Right Harpoon Above / Non-Spacing Right Harpoon Above
  ^^^^20d2%  ⃒  \vertoverlay    Combining Long Vertical Line Overlay / Non-Spacing Long Vertical Bar Overlay
  ^^^^20d6%  ⃖  \overleftarrow  Combining Left Arrow Above / Non-Spacing Left Arrow Above
  ^^^^20d7%  ⃗  \vec    Combining Right Arrow Above / Non-Spacing Right Arrow Above
  ^^^^20db%  ⃛  \dddot  Combining Three Dots Above / Non-Spacing Three Dots Above
  ^^^^20dc%  ⃜  \ddddot Combining Four Dots Above / Non-Spacing Four Dots Above
  ^^^^20dd%  ⃝  \enclosecircle  Combining Enclosing Circle / Enclosing Circle
  ^^^^20de%  ⃞  \enclosesquare  Combining Enclosing Square / Enclosing Square
  ^^^^20df%  ⃟  \enclosediamond Combining Enclosing Diamond / Enclosing Diamond
  ^^^^20e1%  ⃡  \overleftrightarrow Combining Left Right Arrow Above / Non-Spacing Left Right Arrow Above
  ^^^^20e4%  ⃤  \enclosetriangle    Combining Enclosing Upward Pointing Triangle
  ^^^^20e7%  ⃧  \annuity    Combining Annuity Symbol
  ^^^^20e8%  ⃨  \threeunderdot  Combining Triple Underdot
  ^^^^20e9%  ⃩  \widebridgeabove    Combining Wide Bridge Above
  ^^^^20ec%  ⃬  \underrightharpoondown  Combining Rightwards Harpoon With Barb Downwards
  ^^^^20ed%  ⃭  \underleftharpoondown   Combining Leftwards Harpoon With Barb Downwards
  ^^^^20ee%  ⃮  \underleftarrow Combining Left Arrow Below
  ^^^^20ef%  ⃯  \underrightarrow    Combining Right Arrow Below
  ^^^^20f0%  ⃰  \asteraccent    Combining Asterisk Above
  ^^^^2102% ℂ   \bbC    Double-Struck Capital C / Double-Struck C
  ^^^^2107% ℇ   \eulermascheroni    Euler Constant / Eulers
  ^^^^210a% ℊ   \scrg   Script Small G
  ^^^^210b% ℋ   \scrH   Script Capital H / Script H
  ^^^^210c% ℌ   \frakH  Black-Letter Capital H / Black-Letter H
  ^^^^210d% ℍ   \bbH    Double-Struck Capital H / Double-Struck H
  ^^^^210e% ℎ   \planck Planck Constant
  ^^^^210f% ℏ   \hslash Planck Constant Over Two Pi / Planck Constant Over 2 Pi
  ^^^^2110% ℐ   \scrI   Script Capital I / Script I
  ^^^^2111% ℑ   \Im Black-Letter Capital I / Black-Letter I
  ^^^^2112% ℒ   \scrL   Script Capital L / Script L
  ^^^^2113% ℓ   \ell    Script Small L
  ^^^^2115% ℕ   \bbN    Double-Struck Capital N / Double-Struck N
  ^^^^2116% №   \numero Numero Sign / Numero
  ^^^^2118% ℘   \wp Script Capital P / Script P
  ^^^^2119% ℙ   \bbP    Double-Struck Capital P / Double-Struck P
  ^^^^211a% ℚ   \bbQ    Double-Struck Capital Q / Double-Struck Q
  ^^^^211b% ℛ   \scrR   Script Capital R / Script R
  ^^^^211c% ℜ   \Re Black-Letter Capital R / Black-Letter R
  ^^^^211d% ℝ   \bbR    Double-Struck Capital R / Double-Struck R
  ^^^^211e% ℞   \xrat   Prescription Take
  ^^^^2122% ™   \trademark, \:tm:   Trade Mark Sign / Trademark
  ^^^^2124% ℤ   \bbZ    Double-Struck Capital Z / Double-Struck Z
  ^^^^2126% Ω   \ohm    Ohm Sign / Ohm
  ^^^^2127% ℧   \mho    Inverted Ohm Sign / Mho
  ^^^^2128% ℨ   \frakZ  Black-Letter Capital Z / Black-Letter Z
  ^^^^2129% ℩   \turnediota Turned Greek Small Letter Iota
  ^^^^212b% Å   \Angstrom   Angstrom Sign / Angstrom Unit
  ^^^^212c% ℬ   \scrB   Script Capital B / Script B
  ^^^^212d% ℭ   \frakC  Black-Letter Capital C / Black-Letter C
  ^^^^212f% ℯ   \scre, \euler   Script Small E
  ^^^^2130% ℰ   \scrE   Script Capital E / Script E
  ^^^^2131% ℱ   \scrF   Script Capital F / Script F
  ^^^^2132% Ⅎ   \Finv   Turned Capital F / Turned F
  ^^^^2133% ℳ   \scrM   Script Capital M / Script M
  ^^^^2134% ℴ   \scro   Script Small O
  ^^^^2135% ℵ   \aleph  Alef Symbol / First Transfinite Cardinal
  ^^^^2136% ℶ   \beth   Bet Symbol / Second Transfinite Cardinal
  ^^^^2137% ℷ   \gimel  Gimel Symbol / Third Transfinite Cardinal
  ^^^^2138% ℸ   \daleth Dalet Symbol / Fourth Transfinite Cardinal
  ^^^^2139% ℹ   \:information_source:   Information Source
  ^^^^213c% ℼ   \bbpi   Double-Struck Small Pi
  ^^^^213d% ℽ   \bbgamma    Double-Struck Small Gamma
  ^^^^213e% ℾ   \bbGamma    Double-Struck Capital Gamma
  ^^^^213f% ℿ   \bbPi   Double-Struck Capital Pi
  ^^^^2140% ⅀   \bbsum  Double-Struck N-Ary Summation
  ^^^^2141% ⅁   \Game   Turned Sans-Serif Capital G
  ^^^^2142% ⅂   \sansLturned    Turned Sans-Serif Capital L
  ^^^^2143% ⅃   \sansLmirrored  Reversed Sans-Serif Capital L
  ^^^^2144% ⅄   \Yup    Turned Sans-Serif Capital Y
  ^^^^2145% ⅅ   \bbiD   Double-Struck Italic Capital D
  ^^^^2146% ⅆ   \bbid   Double-Struck Italic Small D
  ^^^^2147% ⅇ   \bbie   Double-Struck Italic Small E
  ^^^^2148% ⅈ   \bbii   Double-Struck Italic Small I
  ^^^^2149% ⅉ   \bbij   Double-Struck Italic Small J
  ^^^^214a% ⅊   \PropertyLine   Property Line
  ^^^^214b% ⅋   \upand  Turned Ampersand
  ^^^^2150% ⅐   \1/7    Vulgar Fraction One Seventh
  ^^^^2151% ⅑   \1/9    Vulgar Fraction One Ninth
  ^^^^2152% ⅒   \1/10   Vulgar Fraction One Tenth
  ^^^^2153% ⅓   \1/3    Vulgar Fraction One Third / Fraction One Third
  ^^^^2154% ⅔   \2/3    Vulgar Fraction Two Thirds / Fraction Two Thirds
  ^^^^2155% ⅕   \1/5    Vulgar Fraction One Fifth / Fraction One Fifth
  ^^^^2156% ⅖   \2/5    Vulgar Fraction Two Fifths / Fraction Two Fifths
  ^^^^2157% ⅗   \3/5    Vulgar Fraction Three Fifths / Fraction Three Fifths
  ^^^^2158% ⅘   \4/5    Vulgar Fraction Four Fifths / Fraction Four Fifths
  ^^^^2159% ⅙   \1/6    Vulgar Fraction One Sixth / Fraction One Sixth
  ^^^^215a% ⅚   \5/6    Vulgar Fraction Five Sixths / Fraction Five Sixths
  ^^^^215b% ⅛   \1/8    Vulgar Fraction One Eighth / Fraction One Eighth
  ^^^^215c% ⅜   \3/8    Vulgar Fraction Three Eighths / Fraction Three Eighths
  ^^^^215d% ⅝   \5/8    Vulgar Fraction Five Eighths / Fraction Five Eighths
  ^^^^215e% ⅞   \7/8    Vulgar Fraction Seven Eighths / Fraction Seven Eighths
  ^^^^215f% ⅟   \1/ Fraction Numerator One
  ^^^^2189% ↉   \0/3    Vulgar Fraction Zero Thirds
  ^^^^2190% ←   \leftarrow  Leftwards Arrow / Left Arrow
  ^^^^2191% ↑   \uparrow    Upwards Arrow / Up Arrow
  ^^^^2192% →   \to, \rightarrow    Rightwards Arrow / Right Arrow
  ^^^^2193% ↓   \downarrow  Downwards Arrow / Down Arrow
  ^^^^2194% ↔   \leftrightarrow, \:left_right_arrow:    Left Right Arrow
  ^^^^2195% ↕   \updownarrow, \:arrow_up_down:  Up Down Arrow
  ^^^^2196% ↖   \nwarrow, \:arrow_upper_left:   North West Arrow / Upper Left Arrow
  ^^^^2197% ↗   \nearrow, \:arrow_upper_right:  North East Arrow / Upper Right Arrow
  ^^^^2198% ↘   \searrow, \:arrow_lower_right:  South East Arrow / Lower Right Arrow
  ^^^^2199% ↙   \swarrow, \:arrow_lower_left:   South West Arrow / Lower Left Arrow
  ^^^^219a% ↚   \nleftarrow Leftwards Arrow With Stroke / Left Arrow With Stroke
  ^^^^219b% ↛   \nrightarrow    Rightwards Arrow With Stroke / Right Arrow With Stroke
  ^^^^219c% ↜   \leftwavearrow  Leftwards Wave Arrow / Left Wave Arrow
  ^^^^219d% ↝   \rightwavearrow Rightwards Wave Arrow / Right Wave Arrow
  ^^^^219e% ↞   \twoheadleftarrow   Leftwards Two Headed Arrow / Left Two Headed Arrow
  ^^^^219f% ↟   \twoheaduparrow Upwards Two Headed Arrow / Up Two Headed Arrow
  ^^^^21a0% ↠   \twoheadrightarrow  Rightwards Two Headed Arrow / Right Two Headed Arrow
  ^^^^21a1% ↡   \twoheaddownarrow   Downwards Two Headed Arrow / Down Two Headed Arrow
  ^^^^21a2% ↢   \leftarrowtail  Leftwards Arrow With Tail / Left Arrow With Tail
  ^^^^21a3% ↣   \rightarrowtail Rightwards Arrow With Tail / Right Arrow With Tail
  ^^^^21a4% ↤   \mapsfrom   Leftwards Arrow From Bar / Left Arrow From Bar
  ^^^^21a5% ↥   \mapsup Upwards Arrow From Bar / Up Arrow From Bar
  ^^^^21a6% ↦   \mapsto Rightwards Arrow From Bar / Right Arrow From Bar
  ^^^^21a7% ↧   \mapsdown   Downwards Arrow From Bar / Down Arrow From Bar
  ^^^^21a8% ↨   \updownarrowbar Up Down Arrow With Base
  ^^^^21a9% ↩   \hookleftarrow, \:leftwards_arrow_with_hook:    Leftwards Arrow With Hook / Left Arrow With Hook
  ^^^^21aa% ↪   \hookrightarrow, \:arrow_right_hook:    Rightwards Arrow With Hook / Right Arrow With Hook
  ^^^^21ab% ↫   \looparrowleft  Leftwards Arrow With Loop / Left Arrow With Loop
  ^^^^21ac% ↬   \looparrowright Rightwards Arrow With Loop / Right Arrow With Loop
  ^^^^21ad% ↭   \leftrightsquigarrow    Left Right Wave Arrow
  ^^^^21ae% ↮   \nleftrightarrow    Left Right Arrow With Stroke
  ^^^^21af% ↯   \downzigzagarrow    Downwards Zigzag Arrow / Down Zigzag Arrow
  ^^^^21b0% ↰   \Lsh    Upwards Arrow With Tip Leftwards / Up Arrow With Tip Left
  ^^^^21b1% ↱   \Rsh    Upwards Arrow With Tip Rightwards / Up Arrow With Tip Right
  ^^^^21b2% ↲   \Ldsh   Downwards Arrow With Tip Leftwards / Down Arrow With Tip Left
  ^^^^21b3% ↳   \Rdsh   Downwards Arrow With Tip Rightwards / Down Arrow With Tip Right
  ^^^^21b4% ↴   \linefeed   Rightwards Arrow With Corner Downwards / Right Arrow With Corner Down
  ^^^^21b5% ↵   \carriagereturn Downwards Arrow With Corner Leftwards / Down Arrow With Corner Left
  ^^^^21b6% ↶   \curvearrowleft Anticlockwise Top Semicircle Arrow
  ^^^^21b7% ↷   \curvearrowright    Clockwise Top Semicircle Arrow
  ^^^^21b8% ↸   \barovernorthwestarrow  North West Arrow To Long Bar / Upper Left Arrow To Long Bar
  ^^^^21b9% ↹   \barleftarrowrightarrowbar  Leftwards Arrow To Bar Over Rightwards Arrow To Bar / Left Arrow To Bar Over Right Arrow To Bar
  ^^^^21ba% ↺   \circlearrowleft    Anticlockwise Open Circle Arrow
  ^^^^21bb% ↻   \circlearrowright   Clockwise Open Circle Arrow
  ^^^^21bc% ↼   \leftharpoonup  Leftwards Harpoon With Barb Upwards / Left Harpoon With Barb Up
  ^^^^21bd% ↽   \leftharpoondown    Leftwards Harpoon With Barb Downwards / Left Harpoon With Barb Down
  ^^^^21be% ↾   \upharpoonright Upwards Harpoon With Barb Rightwards / Up Harpoon With Barb Right
  ^^^^21bf% ↿   \upharpoonleft  Upwards Harpoon With Barb Leftwards / Up Harpoon With Barb Left
  ^^^^21c0% ⇀   \rightharpoonup Rightwards Harpoon With Barb Upwards / Right Harpoon With Barb Up
  ^^^^21c1% ⇁   \rightharpoondown   Rightwards Harpoon With Barb Downwards / Right Harpoon With Barb Down
  ^^^^21c2% ⇂   \downharpoonright   Downwards Harpoon With Barb Rightwards / Down Harpoon With Barb Right
  ^^^^21c3% ⇃   \downharpoonleft    Downwards Harpoon With Barb Leftwards / Down Harpoon With Barb Left
  ^^^^21c4% ⇄   \rightleftarrows    Rightwards Arrow Over Leftwards Arrow / Right Arrow Over Left Arrow
  ^^^^21c5% ⇅   \dblarrowupdown Upwards Arrow Leftwards Of Downwards Arrow / Up Arrow Left Of Down Arrow
  ^^^^21c6% ⇆   \leftrightarrows    Leftwards Arrow Over Rightwards Arrow / Left Arrow Over Right Arrow
  ^^^^21c7% ⇇   \leftleftarrows Leftwards Paired Arrows / Left Paired Arrows
  ^^^^21c8% ⇈   \upuparrows Upwards Paired Arrows / Up Paired Arrows
  ^^^^21c9% ⇉   \rightrightarrows   Rightwards Paired Arrows / Right Paired Arrows
  ^^^^21ca% ⇊   \downdownarrows Downwards Paired Arrows / Down Paired Arrows
  ^^^^21cb% ⇋   \leftrightharpoons  Leftwards Harpoon Over Rightwards Harpoon / Left Harpoon Over Right Harpoon
  ^^^^21cc% ⇌   \rightleftharpoons  Rightwards Harpoon Over Leftwards Harpoon / Right Harpoon Over Left Harpoon
  ^^^^21cd% ⇍   \nLeftarrow Leftwards Double Arrow With Stroke / Left Double Arrow With Stroke
  ^^^^21ce% ⇎   \nLeftrightarrow    Left Right Double Arrow With Stroke
  ^^^^21cf% ⇏   \nRightarrow    Rightwards Double Arrow With Stroke / Right Double Arrow With Stroke
  ^^^^21d0% ⇐   \Leftarrow  Leftwards Double Arrow / Left Double Arrow
  ^^^^21d1% ⇑   \Uparrow    Upwards Double Arrow / Up Double Arrow
  ^^^^21d2% ⇒   \Rightarrow Rightwards Double Arrow / Right Double Arrow
  ^^^^21d3% ⇓   \Downarrow  Downwards Double Arrow / Down Double Arrow
  ^^^^21d4% ⇔   \Leftrightarrow Left Right Double Arrow
  ^^^^21d5% ⇕   \Updownarrow    Up Down Double Arrow
  ^^^^21d6% ⇖   \Nwarrow    North West Double Arrow / Upper Left Double Arrow
  ^^^^21d7% ⇗   \Nearrow    North East Double Arrow / Upper Right Double Arrow
  ^^^^21d8% ⇘   \Searrow    South East Double Arrow / Lower Right Double Arrow
  ^^^^21d9% ⇙   \Swarrow    South West Double Arrow / Lower Left Double Arrow
  ^^^^21da% ⇚   \Lleftarrow Leftwards Triple Arrow / Left Triple Arrow
  ^^^^21db% ⇛   \Rrightarrow    Rightwards Triple Arrow / Right Triple Arrow
  ^^^^21dc% ⇜   \leftsquigarrow Leftwards Squiggle Arrow / Left Squiggle Arrow
  ^^^^21dd% ⇝   \rightsquigarrow    Rightwards Squiggle Arrow / Right Squiggle Arrow
  ^^^^21de% ⇞   \nHuparrow  Upwards Arrow With Double Stroke / Up Arrow With Double Stroke
  ^^^^21df% ⇟   \nHdownarrow    Downwards Arrow With Double Stroke / Down Arrow With Double Stroke
  ^^^^21e0% ⇠   \leftdasharrow  Leftwards Dashed Arrow / Left Dashed Arrow
  ^^^^21e1% ⇡   \updasharrow    Upwards Dashed Arrow / Up Dashed Arrow
  ^^^^21e2% ⇢   \rightdasharrow Rightwards Dashed Arrow / Right Dashed Arrow
  ^^^^21e3% ⇣   \downdasharrow  Downwards Dashed Arrow / Down Dashed Arrow
  ^^^^21e4% ⇤   \barleftarrow   Leftwards Arrow To Bar / Left Arrow To Bar
  ^^^^21e5% ⇥   \rightarrowbar  Rightwards Arrow To Bar / Right Arrow To Bar
  ^^^^21e6% ⇦   \leftwhitearrow Leftwards White Arrow / White Left Arrow
  ^^^^21e7% ⇧   \upwhitearrow   Upwards White Arrow / White Up Arrow
  ^^^^21e8% ⇨   \rightwhitearrow    Rightwards White Arrow / White Right Arrow
  ^^^^21e9% ⇩   \downwhitearrow Downwards White Arrow / White Down Arrow
  ^^^^21ea% ⇪   \whitearrowupfrombar    Upwards White Arrow From Bar / White Up Arrow From Bar
  ^^^^21f4% ⇴   \circleonrightarrow Right Arrow With Small Circle
  ^^^^21f5% ⇵   \DownArrowUpArrow   Downwards Arrow Leftwards Of Upwards Arrow
  ^^^^21f6% ⇶   \rightthreearrows   Three Rightwards Arrows
  ^^^^21f7% ⇷   \nvleftarrow    Leftwards Arrow With Vertical Stroke
  ^^^^21f8% ⇸   \nvrightarrow   Rightwards Arrow With Vertical Stroke
  ^^^^21f9% ⇹   \nvleftrightarrow   Left Right Arrow With Vertical Stroke
  ^^^^21fa% ⇺   \nVleftarrow    Leftwards Arrow With Double Vertical Stroke
  ^^^^21fb% ⇻   \nVrightarrow   Rightwards Arrow With Double Vertical Stroke
  ^^^^21fc% ⇼   \nVleftrightarrow   Left Right Arrow With Double Vertical Stroke
  ^^^^21fd% ⇽   \leftarrowtriangle  Leftwards Open-Headed Arrow
  ^^^^21fe% ⇾   \rightarrowtriangle Rightwards Open-Headed Arrow
  ^^^^21ff% ⇿   \leftrightarrowtriangle Left Right Open-Headed Arrow
  ^^^^2200% ∀   \forall For All
  ^^^^2201% ∁   \complement Complement
  ^^^^2202% ∂   \partial    Partial Differential
  ^^^^2203% ∃   \exists There Exists
  ^^^^2204% ∄   \nexists    There Does Not Exist
  ^^^^2205% ∅   \varnothing, \emptyset  Empty Set
  ^^^^2206% ∆   \increment  Increment
  ^^^^2207% ∇   \del, \nabla    Nabla
  ^^^^2208% ∈   \in Element Of
  ^^^^2209% ∉   \notin  Not An Element Of
  ^^^^220a% ∊   \smallin    Small Element Of
  ^^^^220b% ∋   \ni Contains As Member
  ^^^^220c% ∌   \nni    Does Not Contain As Member
  ^^^^220d% ∍   \smallni    Small Contains As Member
  ^^^^220e% ∎   \QED    End Of Proof
  ^^^^220f% ∏   \prod   N-Ary Product
  ^^^^2210% ∐   \coprod N-Ary Coproduct
  ^^^^2211% ∑   \sum    N-Ary Summation
  ^^^^2212% −   \minus  Minus Sign
  ^^^^2213% ∓   \mp Minus-Or-Plus Sign
  ^^^^2214% ∔   \dotplus    Dot Plus
  ^^^^2216% ∖   \setminus   Set Minus
  ^^^^2217% ∗   \ast    Asterisk Operator
  ^^^^2218% ∘   \circ   Ring Operator
  ^^^^2219% ∙   \vysmblkcircle  Bullet Operator
  ^^^^221a% √   \surd, \sqrt    Square Root
  ^^^^221b% ∛   \cbrt   Cube Root
  ^^^^221c% ∜   \fourthroot Fourth Root
  ^^^^221d% ∝   \propto Proportional To
  ^^^^221e% ∞   \infty  Infinity
  ^^^^221f% ∟   \rightangle Right Angle
  ^^^^2220% ∠   \angle  Angle
  ^^^^2221% ∡   \measuredangle  Measured Angle
  ^^^^2222% ∢   \sphericalangle Spherical Angle
  ^^^^2223% ∣   \mid    Divides
  ^^^^2224% ∤   \nmid   Does Not Divide
  ^^^^2225% ∥   \parallel   Parallel To
  ^^^^2226% ∦   \nparallel  Not Parallel To
  ^^^^2227% ∧   \wedge  Logical And
  ^^^^2228% ∨   \vee    Logical Or
  ^^^^2229% ∩   \cap    Intersection
  ^^^^222a% ∪   \cup    Union
  ^^^^222b% ∫   \int    Integral
  ^^^^222c% ∬   \iint   Double Integral
  ^^^^222d% ∭   \iiint  Triple Integral
  ^^^^222e% ∮   \oint   Contour Integral
  ^^^^222f% ∯   \oiint  Surface Integral
  ^^^^2230% ∰   \oiiint Volume Integral
  ^^^^2231% ∱   \clwintegral    Clockwise Integral
  ^^^^2232% ∲   \varointclockwise   Clockwise Contour Integral
  ^^^^2233% ∳   \ointctrclockwise   Anticlockwise Contour Integral
  ^^^^2234% ∴   \therefore  Therefore
  ^^^^2235% ∵   \because    Because
  ^^^^2237% ∷   \Colon  Proportion
  ^^^^2238% ∸   \dotminus   Dot Minus
  ^^^^223a% ∺   \dotsminusdots  Geometric Proportion
  ^^^^223b% ∻   \kernelcontraction  Homothetic
  ^^^^223c% ∼   \sim    Tilde Operator
  ^^^^223d% ∽   \backsim    Reversed Tilde
  ^^^^223e% ∾   \lazysinv   Inverted Lazy S
  ^^^^223f% ∿   \sinewave   Sine Wave
  ^^^^2240% ≀   \wr Wreath Product
  ^^^^2241% ≁   \nsim   Not Tilde
  ^^^^2242% ≂   \eqsim  Minus Tilde
  ^^^^2242% + ^^^^0338%   ≂̸  \neqsim Minus Tilde + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^2243% ≃   \simeq  Asymptotically Equal To
  ^^^^2244% ≄   \nsime  Not Asymptotically Equal To
  ^^^^2245% ≅   \cong   Approximately Equal To
  ^^^^2246% ≆   \approxnotequal Approximately But Not Actually Equal To
  ^^^^2247% ≇   \ncong  Neither Approximately Nor Actually Equal To
  ^^^^2248% ≈   \approx Almost Equal To
  ^^^^2249% ≉   \napprox    Not Almost Equal To
  ^^^^224a% ≊   \approxeq   Almost Equal Or Equal To
  ^^^^224b% ≋   \tildetrpl  Triple Tilde
  ^^^^224c% ≌   \allequal   All Equal To
  ^^^^224d% ≍   \asymp  Equivalent To
  ^^^^224e% ≎   \Bumpeq Geometrically Equivalent To
  ^^^^224e% + ^^^^0338%   ≎̸  \nBumpeq    Geometrically Equivalent To + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^224f% ≏   \bumpeq Difference Between
  ^^^^224f% + ^^^^0338%   ≏̸  \nbumpeq    Difference Between + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^2250% ≐   \doteq  Approaches The Limit
  ^^^^2251% ≑   \Doteq  Geometrically Equal To
  ^^^^2252% ≒   \fallingdotseq  Approximately Equal To Or The Image Of
  ^^^^2253% ≓   \risingdotseq   Image Of Or Approximately Equal To
  ^^^^2254% ≔   \coloneq    Colon Equals / Colon Equal
  ^^^^2255% ≕   \eqcolon    Equals Colon / Equal Colon
  ^^^^2256% ≖   \eqcirc Ring In Equal To
  ^^^^2257% ≗   \circeq Ring Equal To
  ^^^^2258% ≘   \arceq  Corresponds To
  ^^^^2259% ≙   \wedgeq Estimates
  ^^^^225a% ≚   \veeeq  Equiangular To
  ^^^^225b% ≛   \starequal  Star Equals
  ^^^^225c% ≜   \triangleq  Delta Equal To
  ^^^^225d% ≝   \eqdef  Equal To By Definition
  ^^^^225e% ≞   \measeq Measured By
  ^^^^225f% ≟   \questeq    Questioned Equal To
  ^^^^2260% ≠   \ne Not Equal To
  ^^^^2261% ≡   \equiv  Identical To
  ^^^^2262% ≢   \nequiv Not Identical To
  ^^^^2263% ≣   \Equiv  Strictly Equivalent To
  ^^^^2264% ≤   \le, \leq   Less-Than Or Equal To / Less Than Or Equal To
  ^^^^2265% ≥   \ge, \geq   Greater-Than Or Equal To / Greater Than Or Equal To
  ^^^^2266% ≦   \leqq   Less-Than Over Equal To / Less Than Over Equal To
  ^^^^2267% ≧   \geqq   Greater-Than Over Equal To / Greater Than Over Equal To
  ^^^^2268% ≨   \lneqq  Less-Than But Not Equal To / Less Than But Not Equal To
  ^^^^2268% + ^^^^fe00%   ≨︀  \lvertneqq  Less-Than But Not Equal To / Less Than But Not Equal To + Variation Selector-1
  ^^^^2269% ≩   \gneqq  Greater-Than But Not Equal To / Greater Than But Not Equal To
  ^^^^2269% + ^^^^fe00%   ≩︀  \gvertneqq  Greater-Than But Not Equal To / Greater Than But Not Equal To + Variation Selector-1
  ^^^^226a% ≪   \ll Much Less-Than / Much Less Than
  ^^^^226a% + ^^^^0338%   ≪̸  \NotLessLess    Much Less-Than / Much Less Than + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^226b% ≫   \gg Much Greater-Than / Much Greater Than
  ^^^^226b% + ^^^^0338%   ≫̸  \NotGreaterGreater  Much Greater-Than / Much Greater Than + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^226c% ≬   \between    Between
  ^^^^226d% ≭   \nasymp Not Equivalent To
  ^^^^226e% ≮   \nless  Not Less-Than / Not Less Than
  ^^^^226f% ≯   \ngtr   Not Greater-Than / Not Greater Than
  ^^^^2270% ≰   \nleq   Neither Less-Than Nor Equal To / Neither Less Than Nor Equal To
  ^^^^2271% ≱   \ngeq   Neither Greater-Than Nor Equal To / Neither Greater Than Nor Equal To
  ^^^^2272% ≲   \lesssim    Less-Than Or Equivalent To / Less Than Or Equivalent To
  ^^^^2273% ≳   \gtrsim Greater-Than Or Equivalent To / Greater Than Or Equivalent To
  ^^^^2274% ≴   \nlesssim   Neither Less-Than Nor Equivalent To / Neither Less Than Nor Equivalent To
  ^^^^2275% ≵   \ngtrsim    Neither Greater-Than Nor Equivalent To / Neither Greater Than Nor Equivalent To
  ^^^^2276% ≶   \lessgtr    Less-Than Or Greater-Than / Less Than Or Greater Than
  ^^^^2277% ≷   \gtrless    Greater-Than Or Less-Than / Greater Than Or Less Than
  ^^^^2278% ≸   \notlessgreater Neither Less-Than Nor Greater-Than / Neither Less Than Nor Greater Than
  ^^^^2279% ≹   \notgreaterless Neither Greater-Than Nor Less-Than / Neither Greater Than Nor Less Than
  ^^^^227a% ≺   \prec   Precedes
  ^^^^227b% ≻   \succ   Succeeds
  ^^^^227c% ≼   \preccurlyeq    Precedes Or Equal To
  ^^^^227d% ≽   \succcurlyeq    Succeeds Or Equal To
  ^^^^227e% ≾   \precsim    Precedes Or Equivalent To
  ^^^^227e% + ^^^^0338%   ≾̸  \nprecsim   Precedes Or Equivalent To + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^227f% ≿   \succsim    Succeeds Or Equivalent To
  ^^^^227f% + ^^^^0338%   ≿̸  \nsuccsim   Succeeds Or Equivalent To + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^2280% ⊀   \nprec  Does Not Precede
  ^^^^2281% ⊁   \nsucc  Does Not Succeed
  ^^^^2282% ⊂   \subset Subset Of
  ^^^^2283% ⊃   \supset Superset Of
  ^^^^2284% ⊄   \nsubset    Not A Subset Of
  ^^^^2285% ⊅   \nsupset    Not A Superset Of
  ^^^^2286% ⊆   \subseteq   Subset Of Or Equal To
  ^^^^2287% ⊇   \supseteq   Superset Of Or Equal To
  ^^^^2288% ⊈   \nsubseteq  Neither A Subset Of Nor Equal To
  ^^^^2289% ⊉   \nsupseteq  Neither A Superset Of Nor Equal To
  ^^^^228a% ⊊   \subsetneq  Subset Of With Not Equal To / Subset Of Or Not Equal To
  ^^^^228a% + ^^^^fe00%   ⊊︀  \varsubsetneqq  Subset Of With Not Equal To / Subset Of Or Not Equal To + Variation Selector-1
  ^^^^228b% ⊋   \supsetneq  Superset Of With Not Equal To / Superset Of Or Not Equal To
  ^^^^228b% + ^^^^fe00%   ⊋︀  \varsupsetneq   Superset Of With Not Equal To / Superset Of Or Not Equal To + Variation Selector-1
  ^^^^228d% ⊍   \cupdot Multiset Multiplication
  ^^^^228e% ⊎   \uplus  Multiset Union
  ^^^^228f% ⊏   \sqsubset   Square Image Of
  ^^^^228f% + ^^^^0338%   ⊏̸  \NotSquareSubset    Square Image Of + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^2290% ⊐   \sqsupset   Square Original Of
  ^^^^2290% + ^^^^0338%   ⊐̸  \NotSquareSuperset  Square Original Of + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^2291% ⊑   \sqsubseteq Square Image Of Or Equal To
  ^^^^2292% ⊒   \sqsupseteq Square Original Of Or Equal To
  ^^^^2293% ⊓   \sqcap  Square Cap
  ^^^^2294% ⊔   \sqcup  Square Cup
  ^^^^2295% ⊕   \oplus  Circled Plus
  ^^^^2296% ⊖   \ominus Circled Minus
  ^^^^2297% ⊗   \otimes Circled Times
  ^^^^2298% ⊘   \oslash Circled Division Slash
  ^^^^2299% ⊙   \odot   Circled Dot Operator
  ^^^^229a% ⊚   \circledcirc    Circled Ring Operator
  ^^^^229b% ⊛   \circledast Circled Asterisk Operator
  ^^^^229c% ⊜   \circledequal   Circled Equals
  ^^^^229d% ⊝   \circleddash    Circled Dash
  ^^^^229e% ⊞   \boxplus    Squared Plus
  ^^^^229f% ⊟   \boxminus   Squared Minus
  ^^^^22a0% ⊠   \boxtimes   Squared Times
  ^^^^22a1% ⊡   \boxdot Squared Dot Operator
  ^^^^22a2% ⊢   \vdash  Right Tack
  ^^^^22a3% ⊣   \dashv  Left Tack
  ^^^^22a4% ⊤   \top    Down Tack
  ^^^^22a5% ⊥   \bot    Up Tack
  ^^^^22a7% ⊧   \models Models
  ^^^^22a8% ⊨   \vDash  True
  ^^^^22a9% ⊩   \Vdash  Forces
  ^^^^22aa% ⊪   \Vvdash Triple Vertical Bar Right Turnstile
  ^^^^22ab% ⊫   \VDash  Double Vertical Bar Double Right Turnstile
  ^^^^22ac% ⊬   \nvdash Does Not Prove
  ^^^^22ad% ⊭   \nvDash Not True
  ^^^^22ae% ⊮   \nVdash Does Not Force
  ^^^^22af% ⊯   \nVDash Negated Double Vertical Bar Double Right Turnstile
  ^^^^22b0% ⊰   \prurel Precedes Under Relation
  ^^^^22b1% ⊱   \scurel Succeeds Under Relation
  ^^^^22b2% ⊲   \vartriangleleft    Normal Subgroup Of
  ^^^^22b3% ⊳   \vartriangleright   Contains As Normal Subgroup
  ^^^^22b4% ⊴   \trianglelefteq Normal Subgroup Of Or Equal To
  ^^^^22b5% ⊵   \trianglerighteq    Contains As Normal Subgroup Or Equal To
  ^^^^22b6% ⊶   \original   Original Of
  ^^^^22b7% ⊷   \image  Image Of
  ^^^^22b8% ⊸   \multimap   Multimap
  ^^^^22b9% ⊹   \hermitconjmatrix   Hermitian Conjugate Matrix
  ^^^^22ba% ⊺   \intercal   Intercalate
  ^^^^22bb% ⊻   \veebar, \xor   Xor
  ^^^^22bc% ⊼   \barwedge   Nand
  ^^^^22bd% ⊽   \barvee Nor
  ^^^^22be% ⊾   \rightanglearc  Right Angle With Arc
  ^^^^22bf% ⊿   \varlrtriangle  Right Triangle
  ^^^^22c0% ⋀   \bigwedge   N-Ary Logical And
  ^^^^22c1% ⋁   \bigvee N-Ary Logical Or
  ^^^^22c2% ⋂   \bigcap N-Ary Intersection
  ^^^^22c3% ⋃   \bigcup N-Ary Union
  ^^^^22c4% ⋄   \diamond    Diamond Operator
  ^^^^22c5% ⋅   \cdot   Dot Operator
  ^^^^22c6% ⋆   \star   Star Operator
  ^^^^22c7% ⋇   \divideontimes  Division Times
  ^^^^22c8% ⋈   \bowtie Bowtie
  ^^^^22c9% ⋉   \ltimes Left Normal Factor Semidirect Product
  ^^^^22ca% ⋊   \rtimes Right Normal Factor Semidirect Product
  ^^^^22cb% ⋋   \leftthreetimes Left Semidirect Product
  ^^^^22cc% ⋌   \rightthreetimes    Right Semidirect Product
  ^^^^22cd% ⋍   \backsimeq  Reversed Tilde Equals
  ^^^^22ce% ⋎   \curlyvee   Curly Logical Or
  ^^^^22cf% ⋏   \curlywedge Curly Logical And
  ^^^^22d0% ⋐   \Subset Double Subset
  ^^^^22d1% ⋑   \Supset Double Superset
  ^^^^22d2% ⋒   \Cap    Double Intersection
  ^^^^22d3% ⋓   \Cup    Double Union
  ^^^^22d4% ⋔   \pitchfork  Pitchfork
  ^^^^22d5% ⋕   \equalparallel  Equal And Parallel To
  ^^^^22d6% ⋖   \lessdot    Less-Than With Dot / Less Than With Dot
  ^^^^22d7% ⋗   \gtrdot Greater-Than With Dot / Greater Than With Dot
  ^^^^22d8% ⋘   \verymuchless   Very Much Less-Than / Very Much Less Than
  ^^^^22d9% ⋙   \ggg    Very Much Greater-Than / Very Much Greater Than
  ^^^^22da% ⋚   \lesseqgtr  Less-Than Equal To Or Greater-Than / Less Than Equal To Or Greater Than
  ^^^^22db% ⋛   \gtreqless  Greater-Than Equal To Or Less-Than / Greater Than Equal To Or Less Than
  ^^^^22dc% ⋜   \eqless Equal To Or Less-Than / Equal To Or Less Than
  ^^^^22dd% ⋝   \eqgtr  Equal To Or Greater-Than / Equal To Or Greater Than
  ^^^^22de% ⋞   \curlyeqprec    Equal To Or Precedes
  ^^^^22df% ⋟   \curlyeqsucc    Equal To Or Succeeds
  ^^^^22e0% ⋠   \npreccurlyeq   Does Not Precede Or Equal
  ^^^^22e1% ⋡   \nsucccurlyeq   Does Not Succeed Or Equal
  ^^^^22e2% ⋢   \nsqsubseteq    Not Square Image Of Or Equal To
  ^^^^22e3% ⋣   \nsqsupseteq    Not Square Original Of Or Equal To
  ^^^^22e4% ⋤   \sqsubsetneq    Square Image Of Or Not Equal To
  ^^^^22e5% ⋥   \sqspne Square Original Of Or Not Equal To
  ^^^^22e6% ⋦   \lnsim  Less-Than But Not Equivalent To / Less Than But Not Equivalent To
  ^^^^22e7% ⋧   \gnsim  Greater-Than But Not Equivalent To / Greater Than But Not Equivalent To
  ^^^^22e8% ⋨   \precnsim   Precedes But Not Equivalent To
  ^^^^22e9% ⋩   \succnsim   Succeeds But Not Equivalent To
  ^^^^22ea% ⋪   \ntriangleleft  Not Normal Subgroup Of
  ^^^^22eb% ⋫   \ntriangleright Does Not Contain As Normal Subgroup
  ^^^^22ec% ⋬   \ntrianglelefteq    Not Normal Subgroup Of Or Equal To
  ^^^^22ed% ⋭   \ntrianglerighteq   Does Not Contain As Normal Subgroup Or Equal
  ^^^^22ee% ⋮   \vdots  Vertical Ellipsis
  ^^^^22ef% ⋯   \cdots  Midline Horizontal Ellipsis
  ^^^^22f0% ⋰   \adots  Up Right Diagonal Ellipsis
  ^^^^22f1% ⋱   \ddots  Down Right Diagonal Ellipsis
  ^^^^22f2% ⋲   \disin  Element Of With Long Horizontal Stroke
  ^^^^22f3% ⋳   \varisins   Element Of With Vertical Bar At End Of Horizontal Stroke
  ^^^^22f4% ⋴   \isins  Small Element Of With Vertical Bar At End Of Horizontal Stroke
  ^^^^22f5% ⋵   \isindot    Element Of With Dot Above
  ^^^^22f6% ⋶   \varisinobar    Element Of With Overbar
  ^^^^22f7% ⋷   \isinobar   Small Element Of With Overbar
  ^^^^22f8% ⋸   \isinvb Element Of With Underbar
  ^^^^22f9% ⋹   \isinE  Element Of With Two Horizontal Strokes
  ^^^^22fa% ⋺   \nisd   Contains With Long Horizontal Stroke
  ^^^^22fb% ⋻   \varnis Contains With Vertical Bar At End Of Horizontal Stroke
  ^^^^22fc% ⋼   \nis    Small Contains With Vertical Bar At End Of Horizontal Stroke
  ^^^^22fd% ⋽   \varniobar  Contains With Overbar
  ^^^^22fe% ⋾   \niobar Small Contains With Overbar
  ^^^^22ff% ⋿   \bagmember  Z Notation Bag Membership
  ^^^^2300% ⌀   \diameter   Diameter Sign
  ^^^^2302% ⌂   \house  House
  ^^^^2305% ⌅   \varbarwedge    Projective
  ^^^^2306% ⌆   \vardoublebarwedge  Perspective
  ^^^^2308% ⌈   \lceil  Left Ceiling
  ^^^^2309% ⌉   \rceil  Right Ceiling
  ^^^^230a% ⌊   \lfloor Left Floor
  ^^^^230b% ⌋   \rfloor Right Floor
  ^^^^2310% ⌐   \invnot Reversed Not Sign
  ^^^^2311% ⌑   \sqlozenge  Square Lozenge
  ^^^^2312% ⌒   \profline   Arc
  ^^^^2313% ⌓   \profsurf   Segment
  ^^^^2315% ⌕   \recorder   Telephone Recorder
  ^^^^2317% ⌗   \viewdata   Viewdata Square
  ^^^^2319% ⌙   \turnednot  Turned Not Sign
  ^^^^231a% ⌚   \:watch:    Watch
  ^^^^231b% ⌛   \:hourglass:    Hourglass
  ^^^^231c% ⌜   \ulcorner   Top Left Corner
  ^^^^231d% ⌝   \urcorner   Top Right Corner
  ^^^^231e% ⌞   \llcorner   Bottom Left Corner
  ^^^^231f% ⌟   \lrcorner   Bottom Right Corner
  ^^^^2322% ⌢   \frown  Frown
  ^^^^2323% ⌣   \smile  Smile
  ^^^^232c% ⌬   \varhexagonlrbonds  Benzene Ring
  ^^^^2332% ⌲   \conictaper Conical Taper
  ^^^^2336% ⌶   \topbot Apl Functional Symbol I-Beam
  ^^^^233d% ⌽   \obar   Apl Functional Symbol Circle Stile
  ^^^^233f% ⌿   \notslash   Apl Functional Symbol Slash Bar
  ^^^^2340% ⍀   \notbackslash   Apl Functional Symbol Backslash Bar
  ^^^^2353% ⍓   \boxupcaret Apl Functional Symbol Quad Up Caret
  ^^^^2370% ⍰   \boxquestion    Apl Functional Symbol Quad Question
  ^^^^2394% ⎔   \hexagon    Software-Function Symbol
  ^^^^23a3% ⎣   \dlcorn Left Square Bracket Lower Corner
  ^^^^23b0% ⎰   \lmoustache Upper Left Or Lower Right Curly Bracket Section
  ^^^^23b1% ⎱   \rmoustache Upper Right Or Lower Left Curly Bracket Section
  ^^^^23b4% ⎴   \overbracket    Top Square Bracket
  ^^^^23b5% ⎵   \underbracket   Bottom Square Bracket
  ^^^^23b6% ⎶   \bbrktbrk   Bottom Square Bracket Over Top Square Bracket
  ^^^^23b7% ⎷   \sqrtbottom Radical Symbol Bottom
  ^^^^23b8% ⎸   \lvboxline  Left Vertical Box Line
  ^^^^23b9% ⎹   \rvboxline  Right Vertical Box Line
  ^^^^23ce% ⏎   \varcarriagereturn  Return Symbol
  ^^^^23de% ⏞   \overbrace  Top Curly Bracket
  ^^^^23df% ⏟   \underbrace Bottom Curly Bracket
  ^^^^23e2% ⏢   \trapezium  White Trapezium
  ^^^^23e3% ⏣   \benzenr    Benzene Ring With Circle
  ^^^^23e4% ⏤   \strns  Straightness
  ^^^^23e5% ⏥   \fltns  Flatness
  ^^^^23e6% ⏦   \accurrent  Ac Current
  ^^^^23e7% ⏧   \elinters   Electrical Intersection
  ^^^^23e9% ⏩   \:fast_forward: Black Right-Pointing Double Triangle
  ^^^^23ea% ⏪   \:rewind:   Black Left-Pointing Double Triangle
  ^^^^23eb% ⏫   \:arrow_double_up:  Black Up-Pointing Double Triangle
  ^^^^23ec% ⏬   \:arrow_double_down:    Black Down-Pointing Double Triangle
  ^^^^23f0% ⏰   \:alarm_clock:  Alarm Clock
  ^^^^23f3% ⏳   \:hourglass_flowing_sand:   Hourglass With Flowing Sand
  ^^^^2422% ␢   \blanksymbol    Blank Symbol / Blank
  ^^^^2423% ␣   \visiblespace   Open Box
  ^^^^24c2% Ⓜ   \:m:    Circled Latin Capital Letter M
  ^^^^24c8% Ⓢ   \circledS   Circled Latin Capital Letter S
  ^^^^2500% ─       Box Drawings Light Horizontal
  ^^^^2502% │       Box Drawings Light Vertical
  ^^^^253c% ┼       Box Drawings Light Vertical and Horizontal
  ^^^^2506% ┆   \dshfnc Box Drawings Light Triple Dash Vertical / Forms Light Triple Dash Vertical
  ^^^^2519% ┙   \sqfnw  Box Drawings Up Light And Left Heavy / Forms Up Light And Left Heavy
  ^^^^2571% ╱   \diagup Box Drawings Light Diagonal Upper Right To Lower Left / Forms Light Diagonal Upper Right To Lower Left
  ^^^^2572% ╲   \diagdown   Box Drawings Light Diagonal Upper Left To Lower Right / Forms Light Diagonal Upper Left To Lower Right
  ^^^^2580% ▀   \blockuphalf    Upper Half Block
  ^^^^2584% ▄   \blocklowhalf   Lower Half Block
  ^^^^2588% █   \blockfull  Full Block
  ^^^^258c% ▌   \blocklefthalf  Left Half Block
  ^^^^2590% ▐   \blockrighthalf Right Half Block
  ^^^^2591% ░   \blockqtrshaded Light Shade
  ^^^^2592% ▒   \blockhalfshaded    Medium Shade
  ^^^^2593% ▓   \blockthreeqtrshaded    Dark Shade
  ^^^^25a0% ■   \blacksquare    Black Square
  ^^^^25a1% □   \square White Square
  ^^^^25a2% ▢   \squoval    White Square With Rounded Corners
  ^^^^25a3% ▣   \blackinwhitesquare White Square Containing Black Small Square
  ^^^^25a4% ▤   \squarehfill    Square With Horizontal Fill
  ^^^^25a5% ▥   \squarevfill    Square With Vertical Fill
  ^^^^25a6% ▦   \squarehvfill   Square With Orthogonal Crosshatch Fill
  ^^^^25a7% ▧   \squarenwsefill Square With Upper Left To Lower Right Fill
  ^^^^25a8% ▨   \squareneswfill Square With Upper Right To Lower Left Fill
  ^^^^25a9% ▩   \squarecrossfill    Square With Diagonal Crosshatch Fill
  ^^^^25aa% ▪   \smblksquare, \:black_small_square: Black Small Square
  ^^^^25ab% ▫   \smwhtsquare, \:white_small_square: White Small Square
  ^^^^25ac% ▬   \hrectangleblack    Black Rectangle
  ^^^^25ad% ▭   \hrectangle White Rectangle
  ^^^^25ae% ▮   \vrectangleblack    Black Vertical Rectangle
  ^^^^25af% ▯   \vrecto White Vertical Rectangle
  ^^^^25b0% ▰   \parallelogramblack Black Parallelogram
  ^^^^25b1% ▱   \parallelogram  White Parallelogram
  ^^^^25b2% ▲   \bigblacktriangleup Black Up-Pointing Triangle / Black Up Pointing Triangle
  ^^^^25b3% △   \bigtriangleup  White Up-Pointing Triangle / White Up Pointing Triangle
  ^^^^25b4% ▴   \blacktriangle  Black Up-Pointing Small Triangle / Black Up Pointing Small Triangle
  ^^^^25b5% ▵   \vartriangle    White Up-Pointing Small Triangle / White Up Pointing Small Triangle
  ^^^^25b6% ▶   \blacktriangleright, \:arrow_forward:   Black Right-Pointing Triangle / Black Right Pointing Triangle
  ^^^^25b7% ▷   \triangleright  White Right-Pointing Triangle / White Right Pointing Triangle
  ^^^^25b8% ▸   \smallblacktriangleright    Black Right-Pointing Small Triangle / Black Right Pointing Small Triangle
  ^^^^25b9% ▹   \smalltriangleright White Right-Pointing Small Triangle / White Right Pointing Small Triangle
  ^^^^25ba% ►   \blackpointerright  Black Right-Pointing Pointer / Black Right Pointing Pointer
  ^^^^25bb% ▻   \whitepointerright  White Right-Pointing Pointer / White Right Pointing Pointer
  ^^^^25bc% ▼   \bigblacktriangledown   Black Down-Pointing Triangle / Black Down Pointing Triangle
  ^^^^25bd% ▽   \bigtriangledown    White Down-Pointing Triangle / White Down Pointing Triangle
  ^^^^25be% ▾   \blacktriangledown  Black Down-Pointing Small Triangle / Black Down Pointing Small Triangle
  ^^^^25bf% ▿   \triangledown   White Down-Pointing Small Triangle / White Down Pointing Small Triangle
  ^^^^25c0% ◀   \blacktriangleleft, \:arrow_backward:   Black Left-Pointing Triangle / Black Left Pointing Triangle
  ^^^^25c1% ◁   \triangleleft   White Left-Pointing Triangle / White Left Pointing Triangle
  ^^^^25c2% ◂   \smallblacktriangleleft Black Left-Pointing Small Triangle / Black Left Pointing Small Triangle
  ^^^^25c3% ◃   \smalltriangleleft  White Left-Pointing Small Triangle / White Left Pointing Small Triangle
  ^^^^25c4% ◄   \blackpointerleft   Black Left-Pointing Pointer / Black Left Pointing Pointer
  ^^^^25c5% ◅   \whitepointerleft   White Left-Pointing Pointer / White Left Pointing Pointer
  ^^^^25c6% ◆   \mdlgblkdiamond Black Diamond
  ^^^^25c7% ◇   \mdlgwhtdiamond White Diamond
  ^^^^25c8% ◈   \blackinwhitediamond    White Diamond Containing Black Small Diamond
  ^^^^25c9% ◉   \fisheye    Fisheye
  ^^^^25ca% ◊   \lozenge    Lozenge
  ^^^^25cb% ○   \bigcirc    White Circle
  ^^^^25cc% ◌   \dottedcircle   Dotted Circle
  ^^^^25cd% ◍   \circlevertfill Circle With Vertical Fill
  ^^^^25ce% ◎   \bullseye   Bullseye
  ^^^^25cf% ●   \mdlgblkcircle  Black Circle
  ^^^^25d0% ◐   \cirfl  Circle With Left Half Black
  ^^^^25d1% ◑   \cirfr  Circle With Right Half Black
  ^^^^25d2% ◒   \cirfb  Circle With Lower Half Black
  ^^^^25d3% ◓   \circletophalfblack Circle With Upper Half Black
  ^^^^25d4% ◔   \circleurquadblack  Circle With Upper Right Quadrant Black
  ^^^^25d5% ◕   \blackcircleulquadwhite Circle With All But Upper Left Quadrant Black
  ^^^^25d6% ◖   \blacklefthalfcircle    Left Half Black Circle
  ^^^^25d7% ◗   \blackrighthalfcircle   Right Half Black Circle
  ^^^^25d8% ◘   \rvbull Inverse Bullet
  ^^^^25d9% ◙   \inversewhitecircle Inverse White Circle
  ^^^^25da% ◚   \invwhiteupperhalfcircle    Upper Half Inverse White Circle
  ^^^^25db% ◛   \invwhitelowerhalfcircle    Lower Half Inverse White Circle
  ^^^^25dc% ◜   \ularc  Upper Left Quadrant Circular Arc
  ^^^^25dd% ◝   \urarc  Upper Right Quadrant Circular Arc
  ^^^^25de% ◞   \lrarc  Lower Right Quadrant Circular Arc
  ^^^^25df% ◟   \llarc  Lower Left Quadrant Circular Arc
  ^^^^25e0% ◠   \topsemicircle  Upper Half Circle
  ^^^^25e1% ◡   \botsemicircle  Lower Half Circle
  ^^^^25e2% ◢   \lrblacktriangle    Black Lower Right Triangle
  ^^^^25e3% ◣   \llblacktriangle    Black Lower Left Triangle
  ^^^^25e4% ◤   \ulblacktriangle    Black Upper Left Triangle
  ^^^^25e5% ◥   \urblacktriangle    Black Upper Right Triangle
  ^^^^25e6% ◦   \smwhtcircle    White Bullet
  ^^^^25e7% ◧   \sqfl   Square With Left Half Black
  ^^^^25e8% ◨   \sqfr   Square With Right Half Black
  ^^^^25e9% ◩   \squareulblack  Square With Upper Left Diagonal Half Black
  ^^^^25ea% ◪   \sqfse  Square With Lower Right Diagonal Half Black
  ^^^^25eb% ◫   \boxbar White Square With Vertical Bisecting Line
  ^^^^25ec% ◬   \trianglecdot   White Up-Pointing Triangle With Dot / White Up Pointing Triangle With Dot
  ^^^^25ed% ◭   \triangleleftblack  Up-Pointing Triangle With Left Half Black / Up Pointing Triangle With Left Half Black
  ^^^^25ee% ◮   \trianglerightblack Up-Pointing Triangle With Right Half Black / Up Pointing Triangle With Right Half Black
  ^^^^25ef% ◯   \lgwhtcircle    Large Circle
  ^^^^25f0% ◰   \squareulquad   White Square With Upper Left Quadrant
  ^^^^25f1% ◱   \squarellquad   White Square With Lower Left Quadrant
  ^^^^25f2% ◲   \squarelrquad   White Square With Lower Right Quadrant
  ^^^^25f3% ◳   \squareurquad   White Square With Upper Right Quadrant
  ^^^^25f4% ◴   \circleulquad   White Circle With Upper Left Quadrant
  ^^^^25f5% ◵   \circlellquad   White Circle With Lower Left Quadrant
  ^^^^25f6% ◶   \circlelrquad   White Circle With Lower Right Quadrant
  ^^^^25f7% ◷   \circleurquad   White Circle With Upper Right Quadrant
  ^^^^25f8% ◸   \ultriangle Upper Left Triangle
  ^^^^25f9% ◹   \urtriangle Upper Right Triangle
  ^^^^25fa% ◺   \lltriangle Lower Left Triangle
  ^^^^25fb% ◻   \mdwhtsquare, \:white_medium_square:    White Medium Square
  ^^^^25fc% ◼   \mdblksquare, \:black_medium_square:    Black Medium Square
  ^^^^25fd% ◽   \mdsmwhtsquare, \:white_medium_small_square:    White Medium Small Square
  ^^^^25fe% ◾   \mdsmblksquare, \:black_medium_small_square:    Black Medium Small Square
  ^^^^25ff% ◿   \lrtriangle Lower Right Triangle
  ^^^^2600% ☀   \:sunny:    Black Sun With Rays
  ^^^^2601% ☁   \:cloud:    Cloud
  ^^^^2605% ★   \bigstar    Black Star
  ^^^^2606% ☆   \bigwhitestar   White Star
  ^^^^2609% ☉   \astrosun   Sun
  ^^^^260e% ☎   \:phone:    Black Telephone
  ^^^^2611% ☑   \:ballot_box_with_check:    Ballot Box With Check
  ^^^^2614% ☔   \:umbrella: Umbrella With Rain Drops
  ^^^^2615% ☕   \:coffee:   Hot Beverage
  ^^^^261d% ☝   \:point_up: White Up Pointing Index
  ^^^^2621% ☡   \danger Caution Sign
  ^^^^263a% ☺   \:relaxed:  White Smiling Face
  ^^^^263b% ☻   \blacksmiley    Black Smiling Face
  ^^^^263c% ☼   \sun    White Sun With Rays
  ^^^^263d% ☽   \rightmoon  First Quarter Moon
  ^^^^263e% ☾   \leftmoon   Last Quarter Moon
  ^^^^263f% ☿   \mercury    Mercury
  ^^^^2640% ♀   \venus, \female Female Sign
  ^^^^2642% ♂   \male, \mars    Male Sign
  ^^^^2643% ♃   \jupiter    Jupiter
  ^^^^2644% ♄   \saturn Saturn
  ^^^^2645% ♅   \uranus Uranus
  ^^^^2646% ♆   \neptune    Neptune
  ^^^^2647% ♇   \pluto  Pluto
  ^^^^2648% ♈   \aries, \:aries:    Aries
  ^^^^2649% ♉   \taurus, \:taurus:  Taurus
  ^^^^264a% ♊   \gemini, \:gemini:  Gemini
  ^^^^264b% ♋   \cancer, \:cancer:  Cancer
  ^^^^264c% ♌   \leo, \:leo:    Leo
  ^^^^264d% ♍   \virgo, \:virgo:    Virgo
  ^^^^264e% ♎   \libra, \:libra:    Libra
  ^^^^264f% ♏   \scorpio, \:scorpius:   Scorpius
  ^^^^2650% ♐   \sagittarius, \:sagittarius:    Sagittarius
  ^^^^2651% ♑   \capricornus, \:capricorn:  Capricorn
  ^^^^2652% ♒   \aquarius, \:aquarius:  Aquarius
  ^^^^2653% ♓   \pisces, \:pisces:  Pisces
  ^^^^2660% ♠   \spadesuit, \:spades:   Black Spade Suit
  ^^^^2661% ♡   \heartsuit  White Heart Suit
  ^^^^2662% ♢   \diamondsuit    White Diamond Suit
  ^^^^2663% ♣   \clubsuit, \:clubs: Black Club Suit
  ^^^^2664% ♤   \varspadesuit   White Spade Suit
  ^^^^2665% ♥   \varheartsuit, \:hearts:    Black Heart Suit
  ^^^^2666% ♦   \vardiamondsuit, \:diamonds:    Black Diamond Suit
  ^^^^2667% ♧   \varclubsuit    White Club Suit
  ^^^^2668% ♨   \:hotsprings:   Hot Springs
  ^^^^2669% ♩   \quarternote    Quarter Note
  ^^^^266a% ♪   \eighthnote Eighth Note
  ^^^^266b% ♫   \twonotes   Beamed Eighth Notes / Barred Eighth Notes
  ^^^^266d% ♭   \flat   Music Flat Sign / Flat
  ^^^^266e% ♮   \natural    Music Natural Sign / Natural
  ^^^^266f% ♯   \sharp  Music Sharp Sign / Sharp
  ^^^^267b% ♻   \:recycle:  Black Universal Recycling Symbol
  ^^^^267e% ♾   \acidfree   Permanent Paper Sign
  ^^^^267f% ♿   \:wheelchair:   Wheelchair Symbol
  ^^^^2680% ⚀   \dicei  Die Face-1
  ^^^^2681% ⚁   \diceii Die Face-2
  ^^^^2682% ⚂   \diceiii    Die Face-3
  ^^^^2683% ⚃   \diceiv Die Face-4
  ^^^^2684% ⚄   \dicev  Die Face-5
  ^^^^2685% ⚅   \dicevi Die Face-6
  ^^^^2686% ⚆   \circledrightdot    White Circle With Dot Right
  ^^^^2687% ⚇   \circledtwodots White Circle With Two Dots
  ^^^^2688% ⚈   \blackcircledrightdot   Black Circle With White Dot Right
  ^^^^2689% ⚉   \blackcircledtwodots    Black Circle With Two White Dots
  ^^^^2693% ⚓   \:anchor:   Anchor
  ^^^^26a0% ⚠   \:warning:  Warning Sign
  ^^^^26a1% ⚡   \:zap:  High Voltage Sign
  ^^^^26a5% ⚥   \hermaphrodite  Male And Female Sign
  ^^^^26aa% ⚪   \mdwhtcircle, \:white_circle:   Medium White Circle
  ^^^^26ab% ⚫   \mdblkcircle, \:black_circle:   Medium Black Circle
  ^^^^26ac% ⚬   \mdsmwhtcircle  Medium Small White Circle
  ^^^^26b2% ⚲   \neuter Neuter
  ^^^^26bd% ⚽   \:soccer:   Soccer Ball
  ^^^^26be% ⚾   \:baseball: Baseball
  ^^^^26c4% ⛄   \:snowman:  Snowman Without Snow
  ^^^^26c5% ⛅   \:partly_sunny: Sun Behind Cloud
  ^^^^26ce% ⛎   \:ophiuchus:    Ophiuchus
  ^^^^26d4% ⛔   \:no_entry: No Entry
  ^^^^26ea% ⛪   \:church:   Church
  ^^^^26f2% ⛲   \:fountain: Fountain
  ^^^^26f3% ⛳   \:golf: Flag In Hole
  ^^^^26f5% ⛵   \:boat: Sailboat
  ^^^^26fa% ⛺   \:tent: Tent
  ^^^^26fd% ⛽   \:fuelpump: Fuel Pump
  ^^^^2702% ✂   \:scissors: Black Scissors
  ^^^^2705% ✅   \:white_check_mark: White Heavy Check Mark
  ^^^^2708% ✈   \:airplane: Airplane
  ^^^^2709% ✉   \:email:    Envelope
  ^^^^270a% ✊   \:fist: Raised Fist
  ^^^^270b% ✋   \:hand: Raised Hand
  ^^^^270c% ✌   \:v:    Victory Hand
  ^^^^270f% ✏   \:pencil2:  Pencil
  ^^^^2712% ✒   \:black_nib:    Black Nib
  ^^^^2713% ✓   \checkmark  Check Mark
  ^^^^2714% ✔   \:heavy_check_mark: Heavy Check Mark
  ^^^^2716% ✖   \:heavy_multiplication_x:   Heavy Multiplication X
  ^^^^2720% ✠   \maltese    Maltese Cross
  ^^^^2728% ✨   \:sparkles: Sparkles
  ^^^^272a% ✪   \circledstar    Circled White Star
  ^^^^2733% ✳   \:eight_spoked_asterisk:    Eight Spoked Asterisk
  ^^^^2734% ✴   \:eight_pointed_black_star: Eight Pointed Black Star
  ^^^^2736% ✶   \varstar    Six Pointed Black Star
  ^^^^273d% ✽   \dingasterisk   Heavy Teardrop-Spoked Asterisk
  ^^^^2744% ❄   \:snowflake:    Snowflake
  ^^^^2747% ❇   \:sparkle:  Sparkle
  ^^^^274c% ❌   \:x:    Cross Mark
  ^^^^274e% ❎   \:negative_squared_cross_mark:  Negative Squared Cross Mark
  ^^^^2753% ❓   \:question: Black Question Mark Ornament
  ^^^^2754% ❔   \:grey_question:    White Question Mark Ornament
  ^^^^2755% ❕   \:grey_exclamation: White Exclamation Mark Ornament
  ^^^^2757% ❗   \:exclamation:  Heavy Exclamation Mark Symbol
  ^^^^2764% ❤   \:heart:    Heavy Black Heart
  ^^^^2795% ➕   \:heavy_plus_sign:  Heavy Plus Sign
  ^^^^2796% ➖   \:heavy_minus_sign: Heavy Minus Sign
  ^^^^2797% ➗   \:heavy_division_sign:  Heavy Division Sign
  ^^^^279b% ➛   \draftingarrow  Drafting Point Rightwards Arrow / Drafting Point Right Arrow
  ^^^^27a1% ➡   \:arrow_right:  Black Rightwards Arrow / Black Right Arrow
  ^^^^27b0% ➰   \:curly_loop:   Curly Loop
  ^^^^27bf% ➿   \:loop: Double Curly Loop
  ^^^^27c0% ⟀   \threedangle    Three Dimensional Angle
  ^^^^27c1% ⟁   \whiteinwhitetriangle   White Triangle Containing Small White Triangle
  ^^^^27c2% ⟂   \perp   Perpendicular
  ^^^^27c8% ⟈   \bsolhsub   Reverse Solidus Preceding Subset
  ^^^^27c9% ⟉   \suphsol    Superset Preceding Solidus
  ^^^^27d1% ⟑   \wedgedot   And With Dot
  ^^^^27d2% ⟒   \upin   Element Of Opening Upwards
  ^^^^27d5% ⟕   \leftouterjoin  Left Outer Join
  ^^^^27d6% ⟖   \rightouterjoin Right Outer Join
  ^^^^27d7% ⟗   \fullouterjoin  Full Outer Join
  ^^^^27d8% ⟘   \bigbot Large Up Tack
  ^^^^27d9% ⟙   \bigtop Large Down Tack
  ^^^^27e6% ⟦   \llbracket, \openbracketleft    Mathematical Left White Square Bracket
  ^^^^27e7% ⟧   \openbracketright, \rrbracket   Mathematical Right White Square Bracket
  ^^^^27e8% ⟨   \langle Mathematical Left Angle Bracket
  ^^^^27e9% ⟩   \rangle Mathematical Right Angle Bracket
  ^^^^27f0% ⟰   \UUparrow   Upwards Quadruple Arrow
  ^^^^27f1% ⟱   \DDownarrow Downwards Quadruple Arrow
  ^^^^27f5% ⟵   \longleftarrow  Long Leftwards Arrow
  ^^^^27f6% ⟶   \longrightarrow Long Rightwards Arrow
  ^^^^27f7% ⟷   \longleftrightarrow Long Left Right Arrow
  ^^^^27f8% ⟸   \impliedby, \Longleftarrow  Long Leftwards Double Arrow
  ^^^^27f9% ⟹   \implies, \Longrightarrow   Long Rightwards Double Arrow
  ^^^^27fa% ⟺   \Longleftrightarrow, \iff   Long Left Right Double Arrow
  ^^^^27fb% ⟻   \longmapsfrom   Long Leftwards Arrow From Bar
  ^^^^27fc% ⟼   \longmapsto Long Rightwards Arrow From Bar
  ^^^^27fd% ⟽   \Longmapsfrom   Long Leftwards Double Arrow From Bar
  ^^^^27fe% ⟾   \Longmapsto Long Rightwards Double Arrow From Bar
  ^^^^27ff% ⟿   \longrightsquigarrow    Long Rightwards Squiggle Arrow
  ^^^^2900% ⤀   \nvtwoheadrightarrow    Rightwards Two-Headed Arrow With Vertical Stroke
  ^^^^2901% ⤁   \nVtwoheadrightarrow    Rightwards Two-Headed Arrow With Double Vertical Stroke
  ^^^^2902% ⤂   \nvLeftarrow    Leftwards Double Arrow With Vertical Stroke
  ^^^^2903% ⤃   \nvRightarrow   Rightwards Double Arrow With Vertical Stroke
  ^^^^2904% ⤄   \nvLeftrightarrow   Left Right Double Arrow With Vertical Stroke
  ^^^^2905% ⤅   \twoheadmapsto  Rightwards Two-Headed Arrow From Bar
  ^^^^2906% ⤆   \Mapsfrom   Leftwards Double Arrow From Bar
  ^^^^2907% ⤇   \Mapsto Rightwards Double Arrow From Bar
  ^^^^2908% ⤈   \downarrowbarred    Downwards Arrow With Horizontal Stroke
  ^^^^2909% ⤉   \uparrowbarred  Upwards Arrow With Horizontal Stroke
  ^^^^290a% ⤊   \Uuparrow   Upwards Triple Arrow
  ^^^^290b% ⤋   \Ddownarrow Downwards Triple Arrow
  ^^^^290c% ⤌   \leftbkarrow    Leftwards Double Dash Arrow
  ^^^^290d% ⤍   \bkarow Rightwards Double Dash Arrow
  ^^^^290e% ⤎   \leftdbkarrow   Leftwards Triple Dash Arrow
  ^^^^290f% ⤏   \dbkarow    Rightwards Triple Dash Arrow
  ^^^^2910% ⤐   \drbkarrow  Rightwards Two-Headed Triple Dash Arrow
  ^^^^2911% ⤑   \rightdotarrow  Rightwards Arrow With Dotted Stem
  ^^^^2912% ⤒   \UpArrowBar Upwards Arrow To Bar
  ^^^^2913% ⤓   \DownArrowBar   Downwards Arrow To Bar
  ^^^^2914% ⤔   \nvrightarrowtail   Rightwards Arrow With Tail With Vertical Stroke
  ^^^^2915% ⤕   \nVrightarrowtail   Rightwards Arrow With Tail With Double Vertical Stroke
  ^^^^2916% ⤖   \twoheadrightarrowtail  Rightwards Two-Headed Arrow With Tail
  ^^^^2917% ⤗   \nvtwoheadrightarrowtail    Rightwards Two-Headed Arrow With Tail With Vertical Stroke
  ^^^^2918% ⤘   \nVtwoheadrightarrowtail    Rightwards Two-Headed Arrow With Tail With Double Vertical Stroke
  ^^^^291d% ⤝   \diamondleftarrow   Leftwards Arrow To Black Diamond
  ^^^^291e% ⤞   \rightarrowdiamond  Rightwards Arrow To Black Diamond
  ^^^^291f% ⤟   \diamondleftarrowbar    Leftwards Arrow From Bar To Black Diamond
  ^^^^2920% ⤠   \barrightarrowdiamond   Rightwards Arrow From Bar To Black Diamond
  ^^^^2925% ⤥   \hksearow   South East Arrow With Hook
  ^^^^2926% ⤦   \hkswarow   South West Arrow With Hook
  ^^^^2927% ⤧   \tona   North West Arrow And North East Arrow
  ^^^^2928% ⤨   \toea   North East Arrow And South East Arrow
  ^^^^2929% ⤩   \tosa   South East Arrow And South West Arrow
  ^^^^292a% ⤪   \towa   South West Arrow And North West Arrow
  ^^^^292b% ⤫   \rdiagovfdiag   Rising Diagonal Crossing Falling Diagonal
  ^^^^292c% ⤬   \fdiagovrdiag   Falling Diagonal Crossing Rising Diagonal
  ^^^^292d% ⤭   \seovnearrow    South East Arrow Crossing North East Arrow
  ^^^^292e% ⤮   \neovsearrow    North East Arrow Crossing South East Arrow
  ^^^^292f% ⤯   \fdiagovnearrow Falling Diagonal Crossing North East Arrow
  ^^^^2930% ⤰   \rdiagovsearrow Rising Diagonal Crossing South East Arrow
  ^^^^2931% ⤱   \neovnwarrow    North East Arrow Crossing North West Arrow
  ^^^^2932% ⤲   \nwovnearrow    North West Arrow Crossing North East Arrow
  ^^^^2934% ⤴   \:arrow_heading_up: Arrow Pointing Rightwards Then Curving Upwards
  ^^^^2935% ⤵   \:arrow_heading_down:   Arrow Pointing Rightwards Then Curving Downwards
  ^^^^2942% ⥂   \Rlarr  Rightwards Arrow Above Short Leftwards Arrow
  ^^^^2944% ⥄   \rLarr  Short Rightwards Arrow Above Leftwards Arrow
  ^^^^2945% ⥅   \rightarrowplus Rightwards Arrow With Plus Below
  ^^^^2946% ⥆   \leftarrowplus  Leftwards Arrow With Plus Below
  ^^^^2947% ⥇   \rarrx  Rightwards Arrow Through X
  ^^^^2948% ⥈   \leftrightarrowcircle   Left Right Arrow Through Small Circle
  ^^^^2949% ⥉   \twoheaduparrowcircle   Upwards Two-Headed Arrow From Small Circle
  ^^^^294a% ⥊   \leftrightharpoonupdown Left Barb Up Right Barb Down Harpoon
  ^^^^294b% ⥋   \leftrightharpoondownup Left Barb Down Right Barb Up Harpoon
  ^^^^294c% ⥌   \updownharpoonrightleft Up Barb Right Down Barb Left Harpoon
  ^^^^294d% ⥍   \updownharpoonleftright Up Barb Left Down Barb Right Harpoon
  ^^^^294e% ⥎   \LeftRightVector    Left Barb Up Right Barb Up Harpoon
  ^^^^294f% ⥏   \RightUpDownVector  Up Barb Right Down Barb Right Harpoon
  ^^^^2950% ⥐   \DownLeftRightVector    Left Barb Down Right Barb Down Harpoon
  ^^^^2951% ⥑   \LeftUpDownVector   Up Barb Left Down Barb Left Harpoon
  ^^^^2952% ⥒   \LeftVectorBar  Leftwards Harpoon With Barb Up To Bar
  ^^^^2953% ⥓   \RightVectorBar Rightwards Harpoon With Barb Up To Bar
  ^^^^2954% ⥔   \RightUpVectorBar   Upwards Harpoon With Barb Right To Bar
  ^^^^2955% ⥕   \RightDownVectorBar Downwards Harpoon With Barb Right To Bar
  ^^^^2956% ⥖   \DownLeftVectorBar  Leftwards Harpoon With Barb Down To Bar
  ^^^^2957% ⥗   \DownRightVectorBar Rightwards Harpoon With Barb Down To Bar
  ^^^^2958% ⥘   \LeftUpVectorBar    Upwards Harpoon With Barb Left To Bar
  ^^^^2959% ⥙   \LeftDownVectorBar  Downwards Harpoon With Barb Left To Bar
  ^^^^295a% ⥚   \LeftTeeVector  Leftwards Harpoon With Barb Up From Bar
  ^^^^295b% ⥛   \RightTeeVector Rightwards Harpoon With Barb Up From Bar
  ^^^^295c% ⥜   \RightUpTeeVector   Upwards Harpoon With Barb Right From Bar
  ^^^^295d% ⥝   \RightDownTeeVector Downwards Harpoon With Barb Right From Bar
  ^^^^295e% ⥞   \DownLeftTeeVector  Leftwards Harpoon With Barb Down From Bar
  ^^^^295f% ⥟   \DownRightTeeVector Rightwards Harpoon With Barb Down From Bar
  ^^^^2960% ⥠   \LeftUpTeeVector    Upwards Harpoon With Barb Left From Bar
  ^^^^2961% ⥡   \LeftDownTeeVector  Downwards Harpoon With Barb Left From Bar
  ^^^^2962% ⥢   \leftharpoonsupdown Leftwards Harpoon With Barb Up Above Leftwards Harpoon With Barb Down
  ^^^^2963% ⥣   \upharpoonsleftright    Upwards Harpoon With Barb Left Beside Upwards Harpoon With Barb Right
  ^^^^2964% ⥤   \rightharpoonsupdown    Rightwards Harpoon With Barb Up Above Rightwards Harpoon With Barb Down
  ^^^^2965% ⥥   \downharpoonsleftright  Downwards Harpoon With Barb Left Beside Downwards Harpoon With Barb Right
  ^^^^2966% ⥦   \leftrightharpoonsup    Leftwards Harpoon With Barb Up Above Rightwards Harpoon With Barb Up
  ^^^^2967% ⥧   \leftrightharpoonsdown  Leftwards Harpoon With Barb Down Above Rightwards Harpoon With Barb Down
  ^^^^2968% ⥨   \rightleftharpoonsup    Rightwards Harpoon With Barb Up Above Leftwards Harpoon With Barb Up
  ^^^^2969% ⥩   \rightleftharpoonsdown  Rightwards Harpoon With Barb Down Above Leftwards Harpoon With Barb Down
  ^^^^296a% ⥪   \leftharpoonupdash  Leftwards Harpoon With Barb Up Above Long Dash
  ^^^^296b% ⥫   \dashleftharpoondown    Leftwards Harpoon With Barb Down Below Long Dash
  ^^^^296c% ⥬   \rightharpoonupdash Rightwards Harpoon With Barb Up Above Long Dash
  ^^^^296d% ⥭   \dashrightharpoondown   Rightwards Harpoon With Barb Down Below Long Dash
  ^^^^296e% ⥮   \UpEquilibrium  Upwards Harpoon With Barb Left Beside Downwards Harpoon With Barb Right
  ^^^^296f% ⥯   \ReverseUpEquilibrium   Downwards Harpoon With Barb Left Beside Upwards Harpoon With Barb Right
  ^^^^2970% ⥰   \RoundImplies   Right Double Arrow With Rounded Head
  ^^^^2980% ⦀   \Vvert  Triple Vertical Bar Delimiter
  ^^^^2986% ⦆   \Elroang    Right White Parenthesis
  ^^^^2999% ⦙   \ddfnc  Dotted Fence
  ^^^^299b% ⦛   \measuredangleleft  Measured Angle Opening Left
  ^^^^299c% ⦜   \Angle  Right Angle Variant With Square
  ^^^^299d% ⦝   \rightanglemdot Measured Right Angle With Dot
  ^^^^299e% ⦞   \angles Angle With S Inside
  ^^^^299f% ⦟   \angdnr Acute Angle
  ^^^^29a0% ⦠   \lpargt Spherical Angle Opening Left
  ^^^^29a1% ⦡   \sphericalangleup   Spherical Angle Opening Up
  ^^^^29a2% ⦢   \turnangle  Turned Angle
  ^^^^29a3% ⦣   \revangle   Reversed Angle
  ^^^^29a4% ⦤   \angleubar  Angle With Underbar
  ^^^^29a5% ⦥   \revangleubar   Reversed Angle With Underbar
  ^^^^29a6% ⦦   \wideangledown  Oblique Angle Opening Up
  ^^^^29a7% ⦧   \wideangleup    Oblique Angle Opening Down
  ^^^^29a8% ⦨   \measanglerutone    Measured Angle With Open Arm Ending In Arrow Pointing Up And Right
  ^^^^29a9% ⦩   \measanglelutonw    Measured Angle With Open Arm Ending In Arrow Pointing Up And Left
  ^^^^29aa% ⦪   \measanglerdtose    Measured Angle With Open Arm Ending In Arrow Pointing Down And Right
  ^^^^29ab% ⦫   \measangleldtosw    Measured Angle With Open Arm Ending In Arrow Pointing Down And Left
  ^^^^29ac% ⦬   \measangleurtone    Measured Angle With Open Arm Ending In Arrow Pointing Right And Up
  ^^^^29ad% ⦭   \measangleultonw    Measured Angle With Open Arm Ending In Arrow Pointing Left And Up
  ^^^^29ae% ⦮   \measangledrtose    Measured Angle With Open Arm Ending In Arrow Pointing Right And Down
  ^^^^29af% ⦯   \measangledltosw    Measured Angle With Open Arm Ending In Arrow Pointing Left And Down
  ^^^^29b0% ⦰   \revemptyset    Reversed Empty Set
  ^^^^29b1% ⦱   \emptysetobar   Empty Set With Overbar
  ^^^^29b2% ⦲   \emptysetocirc  Empty Set With Small Circle Above
  ^^^^29b3% ⦳   \emptysetoarr   Empty Set With Right Arrow Above
  ^^^^29b4% ⦴   \emptysetoarrl  Empty Set With Left Arrow Above
  ^^^^29b7% ⦷   \circledparallel    Circled Parallel
  ^^^^29b8% ⦸   \obslash    Circled Reverse Solidus
  ^^^^29bc% ⦼   \odotslashdot   Circled Anticlockwise-Rotated Division Sign
  ^^^^29be% ⦾   \circledwhitebullet Circled White Bullet
  ^^^^29bf% ⦿   \circledbullet  Circled Bullet
  ^^^^29c0% ⧀   \olessthan  Circled Less-Than
  ^^^^29c1% ⧁   \ogreaterthan   Circled Greater-Than
  ^^^^29c4% ⧄   \boxdiag    Squared Rising Diagonal Slash
  ^^^^29c5% ⧅   \boxbslash  Squared Falling Diagonal Slash
  ^^^^29c6% ⧆   \boxast Squared Asterisk
  ^^^^29c7% ⧇   \boxcircle  Squared Small Circle
  ^^^^29ca% ⧊   \Lap    Triangle With Dot Above
  ^^^^29cb% ⧋   \defas  Triangle With Underbar
  ^^^^29cf% ⧏   \LeftTriangleBar    Left Triangle Beside Vertical Bar
  ^^^^29cf% + ^^^^0338%   ⧏̸  \NotLeftTriangleBar Left Triangle Beside Vertical Bar + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^29d0% ⧐   \RightTriangleBar   Vertical Bar Beside Right Triangle
  ^^^^29d0% + ^^^^0338%   ⧐̸  \NotRightTriangleBar    Vertical Bar Beside Right Triangle + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^29df% ⧟   \dualmap    Double-Ended Multimap
  ^^^^29e1% ⧡   \lrtriangleeq   Increases As
  ^^^^29e2% ⧢   \shuffle    Shuffle Product
  ^^^^29e3% ⧣   \eparsl Equals Sign And Slanted Parallel
  ^^^^29e4% ⧤   \smeparsl   Equals Sign And Slanted Parallel With Tilde Above
  ^^^^29e5% ⧥   \eqvparsl   Identical To And Slanted Parallel
  ^^^^29eb% ⧫   \blacklozenge   Black Lozenge
  ^^^^29f4% ⧴   \RuleDelayed    Rule-Delayed
  ^^^^29f6% ⧶   \dsol   Solidus With Overbar
  ^^^^29f7% ⧷   \rsolbar    Reverse Solidus With Horizontal Stroke
  ^^^^29fa% ⧺   \doubleplus Double Plus
  ^^^^29fb% ⧻   \tripleplus Triple Plus
  ^^^^2a00% ⨀   \bigodot    N-Ary Circled Dot Operator
  ^^^^2a01% ⨁   \bigoplus   N-Ary Circled Plus Operator
  ^^^^2a02% ⨂   \bigotimes  N-Ary Circled Times Operator
  ^^^^2a03% ⨃   \bigcupdot  N-Ary Union Operator With Dot
  ^^^^2a04% ⨄   \biguplus   N-Ary Union Operator With Plus
  ^^^^2a05% ⨅   \bigsqcap   N-Ary Square Intersection Operator
  ^^^^2a06% ⨆   \bigsqcup   N-Ary Square Union Operator
  ^^^^2a07% ⨇   \conjquant  Two Logical And Operator
  ^^^^2a08% ⨈   \disjquant  Two Logical Or Operator
  ^^^^2a09% ⨉   \bigtimes   N-Ary Times Operator
  ^^^^2a0a% ⨊   \modtwosum  Modulo Two Sum
  ^^^^2a0b% ⨋   \sumint Summation With Integral
  ^^^^2a0c% ⨌   \iiiint Quadruple Integral Operator
  ^^^^2a0d% ⨍   \intbar Finite Part Integral
  ^^^^2a0e% ⨎   \intBar Integral With Double Stroke
  ^^^^2a0f% ⨏   \clockoint  Integral Average With Slash
  ^^^^2a10% ⨐   \cirfnint   Circulation Function
  ^^^^2a11% ⨑   \awint  Anticlockwise Integration
  ^^^^2a12% ⨒   \rppolint   Line Integration With Rectangular Path Around Pole
  ^^^^2a13% ⨓   \scpolint   Line Integration With Semicircular Path Around Pole
  ^^^^2a14% ⨔   \npolint    Line Integration Not Including The Pole
  ^^^^2a15% ⨕   \pointint   Integral Around A Point Operator
  ^^^^2a16% ⨖   \sqrint Quaternion Integral Operator
  ^^^^2a18% ⨘   \intx   Integral With Times Sign
  ^^^^2a19% ⨙   \intcap Integral With Intersection
  ^^^^2a1a% ⨚   \intcup Integral With Union
  ^^^^2a1b% ⨛   \upint  Integral With Overbar
  ^^^^2a1c% ⨜   \lowint Integral With Underbar
  ^^^^2a1d% ⨝   \Join, \join    Join
  ^^^^2a1f% ⨟   \bbsemi Z Notation Schema Composition
  ^^^^2a22% ⨢   \ringplus   Plus Sign With Small Circle Above
  ^^^^2a23% ⨣   \plushat    Plus Sign With Circumflex Accent Above
  ^^^^2a24% ⨤   \simplus    Plus Sign With Tilde Above
  ^^^^2a25% ⨥   \plusdot    Plus Sign With Dot Below
  ^^^^2a26% ⨦   \plussim    Plus Sign With Tilde Below
  ^^^^2a27% ⨧   \plussubtwo Plus Sign With Subscript Two
  ^^^^2a28% ⨨   \plustrif   Plus Sign With Black Triangle
  ^^^^2a29% ⨩   \commaminus Minus Sign With Comma Above
  ^^^^2a2a% ⨪   \minusdot   Minus Sign With Dot Below
  ^^^^2a2b% ⨫   \minusfdots Minus Sign With Falling Dots
  ^^^^2a2c% ⨬   \minusrdots Minus Sign With Rising Dots
  ^^^^2a2d% ⨭   \opluslhrim Plus Sign In Left Half Circle
  ^^^^2a2e% ⨮   \oplusrhrim Plus Sign In Right Half Circle
  ^^^^2a2f% ⨯   \Times  Vector Or Cross Product
  ^^^^2a30% ⨰   \dottimes   Multiplication Sign With Dot Above
  ^^^^2a31% ⨱   \timesbar   Multiplication Sign With Underbar
  ^^^^2a32% ⨲   \btimes Semidirect Product With Bottom Closed
  ^^^^2a33% ⨳   \smashtimes Smash Product
  ^^^^2a34% ⨴   \otimeslhrim    Multiplication Sign In Left Half Circle
  ^^^^2a35% ⨵   \otimesrhrim    Multiplication Sign In Right Half Circle
  ^^^^2a36% ⨶   \otimeshat  Circled Multiplication Sign With Circumflex Accent
  ^^^^2a37% ⨷   \Otimes Multiplication Sign In Double Circle
  ^^^^2a38% ⨸   \odiv   Circled Division Sign
  ^^^^2a39% ⨹   \triangleplus   Plus Sign In Triangle
  ^^^^2a3a% ⨺   \triangleminus  Minus Sign In Triangle
  ^^^^2a3b% ⨻   \triangletimes  Multiplication Sign In Triangle
  ^^^^2a3c% ⨼   \intprod    Interior Product
  ^^^^2a3d% ⨽   \intprodr   Righthand Interior Product
  ^^^^2a3f% ⨿   \amalg  Amalgamation Or Coproduct
  ^^^^2a40% ⩀   \capdot Intersection With Dot
  ^^^^2a41% ⩁   \uminus Union With Minus Sign
  ^^^^2a42% ⩂   \barcup Union With Overbar
  ^^^^2a43% ⩃   \barcap Intersection With Overbar
  ^^^^2a44% ⩄   \capwedge   Intersection With Logical And
  ^^^^2a45% ⩅   \cupvee Union With Logical Or
  ^^^^2a4a% ⩊   \twocups    Union Beside And Joined With Union
  ^^^^2a4b% ⩋   \twocaps    Intersection Beside And Joined With Intersection
  ^^^^2a4c% ⩌   \closedvarcup   Closed Union With Serifs
  ^^^^2a4d% ⩍   \closedvarcap   Closed Intersection With Serifs
  ^^^^2a4e% ⩎   \Sqcap  Double Square Intersection
  ^^^^2a4f% ⩏   \Sqcup  Double Square Union
  ^^^^2a50% ⩐   \closedvarcupsmashprod  Closed Union With Serifs And Smash Product
  ^^^^2a51% ⩑   \wedgeodot  Logical And With Dot Above
  ^^^^2a52% ⩒   \veeodot    Logical Or With Dot Above
  ^^^^2a53% ⩓   \And    Double Logical And
  ^^^^2a54% ⩔   \Or Double Logical Or
  ^^^^2a55% ⩕   \wedgeonwedge   Two Intersecting Logical And
  ^^^^2a56% ⩖   \ElOr   Two Intersecting Logical Or
  ^^^^2a57% ⩗   \bigslopedvee   Sloping Large Or
  ^^^^2a58% ⩘   \bigslopedwedge Sloping Large And
  ^^^^2a5a% ⩚   \wedgemidvert   Logical And With Middle Stem
  ^^^^2a5b% ⩛   \veemidvert Logical Or With Middle Stem
  ^^^^2a5c% ⩜   \midbarwedge    Logical And With Horizontal Dash
  ^^^^2a5d% ⩝   \midbarvee  Logical Or With Horizontal Dash
  ^^^^2a5e% ⩞   \perspcorrespond    Logical And With Double Overbar
  ^^^^2a5f% ⩟   \minhat Logical And With Underbar
  ^^^^2a60% ⩠   \wedgedoublebar Logical And With Double Underbar
  ^^^^2a61% ⩡   \varveebar  Small Vee With Underbar
  ^^^^2a62% ⩢   \doublebarvee   Logical Or With Double Overbar
  ^^^^2a63% ⩣   \veedoublebar   Logical Or With Double Underbar
  ^^^^2a66% ⩦   \eqdot  Equals Sign With Dot Below
  ^^^^2a67% ⩧   \dotequiv   Identical With Dot Above
  ^^^^2a6a% ⩪   \dotsim Tilde Operator With Dot Above
  ^^^^2a6b% ⩫   \simrdots   Tilde Operator With Rising Dots
  ^^^^2a6c% ⩬   \simminussim    Similar Minus Similar
  ^^^^2a6d% ⩭   \congdot    Congruent With Dot Above
  ^^^^2a6e% ⩮   \asteq  Equals With Asterisk
  ^^^^2a6f% ⩯   \hatapprox  Almost Equal To With Circumflex Accent
  ^^^^2a70% ⩰   \approxeqq  Approximately Equal Or Equal To
  ^^^^2a71% ⩱   \eqqplus    Equals Sign Above Plus Sign
  ^^^^2a72% ⩲   \pluseqq    Plus Sign Above Equals Sign
  ^^^^2a73% ⩳   \eqqsim Equals Sign Above Tilde Operator
  ^^^^2a74% ⩴   \Coloneq    Double Colon Equal
  ^^^^2a75% ⩵   \Equal  Two Consecutive Equals Signs
  ^^^^2a76% ⩶   \eqeqeq Three Consecutive Equals Signs
  ^^^^2a77% ⩷   \ddotseq    Equals Sign With Two Dots Above And Two Dots Below
  ^^^^2a78% ⩸   \equivDD    Equivalent With Four Dots Above
  ^^^^2a79% ⩹   \ltcir  Less-Than With Circle Inside
  ^^^^2a7a% ⩺   \gtcir  Greater-Than With Circle Inside
  ^^^^2a7b% ⩻   \ltquest    Less-Than With Question Mark Above
  ^^^^2a7c% ⩼   \gtquest    Greater-Than With Question Mark Above
  ^^^^2a7d% ⩽   \leqslant   Less-Than Or Slanted Equal To
  ^^^^2a7d% + ^^^^0338%   ⩽̸  \nleqslant  Less-Than Or Slanted Equal To + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^2a7e% ⩾   \geqslant   Greater-Than Or Slanted Equal To
  ^^^^2a7e% + ^^^^0338%   ⩾̸  \ngeqslant  Greater-Than Or Slanted Equal To + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^2a7f% ⩿   \lesdot Less-Than Or Slanted Equal To With Dot Inside
  ^^^^2a80% ⪀   \gesdot Greater-Than Or Slanted Equal To With Dot Inside
  ^^^^2a81% ⪁   \lesdoto    Less-Than Or Slanted Equal To With Dot Above
  ^^^^2a82% ⪂   \gesdoto    Greater-Than Or Slanted Equal To With Dot Above
  ^^^^2a83% ⪃   \lesdotor   Less-Than Or Slanted Equal To With Dot Above Right
  ^^^^2a84% ⪄   \gesdotol   Greater-Than Or Slanted Equal To With Dot Above Left
  ^^^^2a85% ⪅   \lessapprox Less-Than Or Approximate
  ^^^^2a86% ⪆   \gtrapprox  Greater-Than Or Approximate
  ^^^^2a87% ⪇   \lneq   Less-Than And Single-Line Not Equal To
  ^^^^2a88% ⪈   \gneq   Greater-Than And Single-Line Not Equal To
  ^^^^2a89% ⪉   \lnapprox   Less-Than And Not Approximate
  ^^^^2a8a% ⪊   \gnapprox   Greater-Than And Not Approximate
  ^^^^2a8b% ⪋   \lesseqqgtr Less-Than Above Double-Line Equal Above Greater-Than
  ^^^^2a8c% ⪌   \gtreqqless Greater-Than Above Double-Line Equal Above Less-Than
  ^^^^2a8d% ⪍   \lsime  Less-Than Above Similar Or Equal
  ^^^^2a8e% ⪎   \gsime  Greater-Than Above Similar Or Equal
  ^^^^2a8f% ⪏   \lsimg  Less-Than Above Similar Above Greater-Than
  ^^^^2a90% ⪐   \gsiml  Greater-Than Above Similar Above Less-Than
  ^^^^2a91% ⪑   \lgE    Less-Than Above Greater-Than Above Double-Line Equal
  ^^^^2a92% ⪒   \glE    Greater-Than Above Less-Than Above Double-Line Equal
  ^^^^2a93% ⪓   \lesges Less-Than Above Slanted Equal Above Greater-Than Above Slanted Equal
  ^^^^2a94% ⪔   \gesles Greater-Than Above Slanted Equal Above Less-Than Above Slanted Equal
  ^^^^2a95% ⪕   \eqslantless    Slanted Equal To Or Less-Than
  ^^^^2a96% ⪖   \eqslantgtr Slanted Equal To Or Greater-Than
  ^^^^2a97% ⪗   \elsdot Slanted Equal To Or Less-Than With Dot Inside
  ^^^^2a98% ⪘   \egsdot Slanted Equal To Or Greater-Than With Dot Inside
  ^^^^2a99% ⪙   \eqqless    Double-Line Equal To Or Less-Than
  ^^^^2a9a% ⪚   \eqqgtr Double-Line Equal To Or Greater-Than
  ^^^^2a9b% ⪛   \eqqslantless   Double-Line Slanted Equal To Or Less-Than
  ^^^^2a9c% ⪜   \eqqslantgtr    Double-Line Slanted Equal To Or Greater-Than
  ^^^^2a9d% ⪝   \simless    Similar Or Less-Than
  ^^^^2a9e% ⪞   \simgtr Similar Or Greater-Than
  ^^^^2a9f% ⪟   \simlE  Similar Above Less-Than Above Equals Sign
  ^^^^2aa0% ⪠   \simgE  Similar Above Greater-Than Above Equals Sign
  ^^^^2aa1% ⪡   \NestedLessLess Double Nested Less-Than
  ^^^^2aa1% + ^^^^0338%   ⪡̸  \NotNestedLessLess  Double Nested Less-Than + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^2aa2% ⪢   \NestedGreaterGreater   Double Nested Greater-Than
  ^^^^2aa2% + ^^^^0338%   ⪢̸  \NotNestedGreaterGreater    Double Nested Greater-Than + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^2aa3% ⪣   \partialmeetcontraction Double Nested Less-Than With Underbar
  ^^^^2aa4% ⪤   \glj    Greater-Than Overlapping Less-Than
  ^^^^2aa5% ⪥   \gla    Greater-Than Beside Less-Than
  ^^^^2aa6% ⪦   \ltcc   Less-Than Closed By Curve
  ^^^^2aa7% ⪧   \gtcc   Greater-Than Closed By Curve
  ^^^^2aa8% ⪨   \lescc  Less-Than Closed By Curve Above Slanted Equal
  ^^^^2aa9% ⪩   \gescc  Greater-Than Closed By Curve Above Slanted Equal
  ^^^^2aaa% ⪪   \smt    Smaller Than
  ^^^^2aab% ⪫   \lat    Larger Than
  ^^^^2aac% ⪬   \smte   Smaller Than Or Equal To
  ^^^^2aad% ⪭   \late   Larger Than Or Equal To
  ^^^^2aae% ⪮   \bumpeqq    Equals Sign With Bumpy Above
  ^^^^2aaf% ⪯   \preceq Precedes Above Single-Line Equals Sign
  ^^^^2aaf% + ^^^^0338%   ⪯̸  \npreceq    Precedes Above Single-Line Equals Sign + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^2ab0% ⪰   \succeq Succeeds Above Single-Line Equals Sign
  ^^^^2ab0% + ^^^^0338%   ⪰̸  \nsucceq    Succeeds Above Single-Line Equals Sign + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^2ab1% ⪱   \precneq    Precedes Above Single-Line Not Equal To
  ^^^^2ab2% ⪲   \succneq    Succeeds Above Single-Line Not Equal To
  ^^^^2ab3% ⪳   \preceqq    Precedes Above Equals Sign
  ^^^^2ab4% ⪴   \succeqq    Succeeds Above Equals Sign
  ^^^^2ab5% ⪵   \precneqq   Precedes Above Not Equal To
  ^^^^2ab6% ⪶   \succneqq   Succeeds Above Not Equal To
  ^^^^2ab7% ⪷   \precapprox Precedes Above Almost Equal To
  ^^^^2ab8% ⪸   \succapprox Succeeds Above Almost Equal To
  ^^^^2ab9% ⪹   \precnapprox    Precedes Above Not Almost Equal To
  ^^^^2aba% ⪺   \succnapprox    Succeeds Above Not Almost Equal To
  ^^^^2abb% ⪻   \Prec   Double Precedes
  ^^^^2abc% ⪼   \Succ   Double Succeeds
  ^^^^2abd% ⪽   \subsetdot  Subset With Dot
  ^^^^2abe% ⪾   \supsetdot  Superset With Dot
  ^^^^2abf% ⪿   \subsetplus Subset With Plus Sign Below
  ^^^^2ac0% ⫀   \supsetplus Superset With Plus Sign Below
  ^^^^2ac1% ⫁   \submult    Subset With Multiplication Sign Below
  ^^^^2ac2% ⫂   \supmult    Superset With Multiplication Sign Below
  ^^^^2ac3% ⫃   \subedot    Subset Of Or Equal To With Dot Above
  ^^^^2ac4% ⫄   \supedot    Superset Of Or Equal To With Dot Above
  ^^^^2ac5% ⫅   \subseteqq  Subset Of Above Equals Sign
  ^^^^2ac5% + ^^^^0338%   ⫅̸  \nsubseteqq Subset Of Above Equals Sign + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^2ac6% ⫆   \supseteqq  Superset Of Above Equals Sign
  ^^^^2ac6% + ^^^^0338%   ⫆̸  \nsupseteqq Superset Of Above Equals Sign + Combining Long Solidus Overlay / Non-Spacing Long Slash Overlay
  ^^^^2ac7% ⫇   \subsim Subset Of Above Tilde Operator
  ^^^^2ac8% ⫈   \supsim Superset Of Above Tilde Operator
  ^^^^2ac9% ⫉   \subsetapprox   Subset Of Above Almost Equal To
  ^^^^2aca% ⫊   \supsetapprox   Superset Of Above Almost Equal To
  ^^^^2acb% ⫋   \subsetneqq Subset Of Above Not Equal To
  ^^^^2acc% ⫌   \supsetneqq Superset Of Above Not Equal To
  ^^^^2acd% ⫍   \lsqhook    Square Left Open Box Operator
  ^^^^2ace% ⫎   \rsqhook    Square Right Open Box Operator
  ^^^^2acf% ⫏   \csub   Closed Subset
  ^^^^2ad0% ⫐   \csup   Closed Superset
  ^^^^2ad1% ⫑   \csube  Closed Subset Or Equal To
  ^^^^2ad2% ⫒   \csupe  Closed Superset Or Equal To
  ^^^^2ad3% ⫓   \subsup Subset Above Superset
  ^^^^2ad4% ⫔   \supsub Superset Above Subset
  ^^^^2ad5% ⫕   \subsub Subset Above Subset
  ^^^^2ad6% ⫖   \supsup Superset Above Superset
  ^^^^2ad7% ⫗   \suphsub    Superset Beside Subset
  ^^^^2ad8% ⫘   \supdsub    Superset Beside And Joined By Dash With Subset
  ^^^^2ad9% ⫙   \forkv  Element Of Opening Downwards
  ^^^^2adb% ⫛   \mlcp   Transversal Intersection
  ^^^^2adc% ⫝̸   \forks  Forking
  ^^^^2add% ⫝   \forksnot   Nonforking
  ^^^^2ae3% ⫣   \dashV  Double Vertical Bar Left Turnstile
  ^^^^2ae4% ⫤   \Dashv  Vertical Bar Double Left Turnstile
  ^^^^2af4% ⫴   \interleave Triple Vertical Bar Binary Relation
  ^^^^2af6% ⫶   \tdcol  Triple Colon Operator
  ^^^^2af7% ⫷   \lllnest    Triple Nested Less-Than
  ^^^^2af8% ⫸   \gggnest    Triple Nested Greater-Than
  ^^^^2af9% ⫹   \leqqslant  Double-Line Slanted Less-Than Or Equal To
  ^^^^2afa% ⫺   \geqqslant  Double-Line Slanted Greater-Than Or Equal To
  ^^^^2b05% ⬅   \:arrow_left:   Leftwards Black Arrow
  ^^^^2b06% ⬆   \:arrow_up: Upwards Black Arrow
  ^^^^2b07% ⬇   \:arrow_down:   Downwards Black Arrow
  ^^^^2b12% ⬒   \squaretopblack Square With Top Half Black
  ^^^^2b13% ⬓   \squarebotblack Square With Bottom Half Black
  ^^^^2b14% ⬔   \squareurblack  Square With Upper Right Diagonal Half Black
  ^^^^2b15% ⬕   \squarellblack  Square With Lower Left Diagonal Half Black
  ^^^^2b16% ⬖   \diamondleftblack   Diamond With Left Half Black
  ^^^^2b17% ⬗   \diamondrightblack  Diamond With Right Half Black
  ^^^^2b18% ⬘   \diamondtopblack    Diamond With Top Half Black
  ^^^^2b19% ⬙   \diamondbotblack    Diamond With Bottom Half Black
  ^^^^2b1a% ⬚   \dottedsquare   Dotted Square
  ^^^^2b1b% ⬛   \lgblksquare, \:black_large_square: Black Large Square
  ^^^^2b1c% ⬜   \lgwhtsquare, \:white_large_square: White Large Square
  ^^^^2b1d% ⬝   \vysmblksquare  Black Very Small Square
  ^^^^2b1e% ⬞   \vysmwhtsquare  White Very Small Square
  ^^^^2b1f% ⬟   \pentagonblack  Black Pentagon
  ^^^^2b20% ⬠   \pentagon   White Pentagon
  ^^^^2b21% ⬡   \varhexagon White Hexagon
  ^^^^2b22% ⬢   \varhexagonblack    Black Hexagon
  ^^^^2b23% ⬣   \hexagonblack   Horizontal Black Hexagon
  ^^^^2b24% ⬤   \lgblkcircle    Black Large Circle
  ^^^^2b25% ⬥   \mdblkdiamond   Black Medium Diamond
  ^^^^2b26% ⬦   \mdwhtdiamond   White Medium Diamond
  ^^^^2b27% ⬧   \mdblklozenge   Black Medium Lozenge
  ^^^^2b28% ⬨   \mdwhtlozenge   White Medium Lozenge
  ^^^^2b29% ⬩   \smblkdiamond   Black Small Diamond
  ^^^^2b2a% ⬪   \smblklozenge   Black Small Lozenge
  ^^^^2b2b% ⬫   \smwhtlozenge   White Small Lozenge
  ^^^^2b2c% ⬬   \blkhorzoval    Black Horizontal Ellipse
  ^^^^2b2d% ⬭   \whthorzoval    White Horizontal Ellipse
  ^^^^2b2e% ⬮   \blkvertoval    Black Vertical Ellipse
  ^^^^2b2f% ⬯   \whtvertoval    White Vertical Ellipse
  ^^^^2b30% ⬰   \circleonleftarrow  Left Arrow With Small Circle
  ^^^^2b31% ⬱   \leftthreearrows    Three Leftwards Arrows
  ^^^^2b32% ⬲   \leftarrowonoplus   Left Arrow With Circled Plus
  ^^^^2b33% ⬳   \longleftsquigarrow Long Leftwards Squiggle Arrow
  ^^^^2b34% ⬴   \nvtwoheadleftarrow Leftwards Two-Headed Arrow With Vertical Stroke
  ^^^^2b35% ⬵   \nVtwoheadleftarrow Leftwards Two-Headed Arrow With Double Vertical Stroke
  ^^^^2b36% ⬶   \twoheadmapsfrom    Leftwards Two-Headed Arrow From Bar
  ^^^^2b37% ⬷   \twoheadleftdbkarrow    Leftwards Two-Headed Triple Dash Arrow
  ^^^^2b38% ⬸   \leftdotarrow   Leftwards Arrow With Dotted Stem
  ^^^^2b39% ⬹   \nvleftarrowtail    Leftwards Arrow With Tail With Vertical Stroke
  ^^^^2b3a% ⬺   \nVleftarrowtail    Leftwards Arrow With Tail With Double Vertical Stroke
  ^^^^2b3b% ⬻   \twoheadleftarrowtail   Leftwards Two-Headed Arrow With Tail
  ^^^^2b3c% ⬼   \nvtwoheadleftarrowtail Leftwards Two-Headed Arrow With Tail With Vertical Stroke
  ^^^^2b3d% ⬽   \nVtwoheadleftarrowtail Leftwards Two-Headed Arrow With Tail With Double Vertical Stroke
  ^^^^2b3e% ⬾   \leftarrowx Leftwards Arrow Through X
  ^^^^2b3f% ⬿   \leftcurvedarrow    Wave Arrow Pointing Directly Left
  ^^^^2b40% ⭀   \equalleftarrow Equals Sign Above Leftwards Arrow
  ^^^^2b41% ⭁   \bsimilarleftarrow  Reverse Tilde Operator Above Leftwards Arrow
  ^^^^2b42% ⭂   \leftarrowbackapprox    Leftwards Arrow Above Reverse Almost Equal To
  ^^^^2b43% ⭃   \rightarrowgtr  Rightwards Arrow Through Greater-Than
  ^^^^2b44% ⭄   \rightarrowsupset   Rightwards Arrow Through Superset
  ^^^^2b45% ⭅   \LLeftarrow Leftwards Quadruple Arrow
  ^^^^2b46% ⭆   \RRightarrow    Rightwards Quadruple Arrow
  ^^^^2b47% ⭇   \bsimilarrightarrow Reverse Tilde Operator Above Rightwards Arrow
  ^^^^2b48% ⭈   \rightarrowbackapprox   Rightwards Arrow Above Reverse Almost Equal To
  ^^^^2b49% ⭉   \similarleftarrow   Tilde Operator Above Leftwards Arrow
  ^^^^2b4a% ⭊   \leftarrowapprox    Leftwards Arrow Above Almost Equal To
  ^^^^2b4b% ⭋   \leftarrowbsimilar  Leftwards Arrow Above Reverse Tilde Operator
  ^^^^2b4c% ⭌   \rightarrowbsimilar Rightwards Arrow Above Reverse Tilde Operator
  ^^^^2b50% ⭐   \medwhitestar, \:star:  White Medium Star
  ^^^^2b51% ⭑   \medblackstar   Black Small Star
  ^^^^2b52% ⭒   \smwhitestar    White Small Star
  ^^^^2b53% ⭓   \rightpentagonblack Black Right-Pointing Pentagon
  ^^^^2b54% ⭔   \rightpentagon  White Right-Pointing Pentagon
  ^^^^2b55% ⭕   \:o:    Heavy Large Circle
  ^^^^2c7c% ⱼ   \_j Latin Subscript Small Letter J
  ^^^^2c7d% ⱽ   \^V Modifier Letter Capital V
  ^^^^3012% 〒   \postalmark Postal Mark
  ^^^^3030% 〰   \:wavy_dash:    Wavy Dash
  ^^^^303d% 〽   \:part_alternation_mark:    Part Alternation Mark
  ^^^^3297% ㊗   \:congratulations:  Circled Ideograph Congratulation
  ^^^^3299% ㊙   \:secret:   Circled Ideograph Secret
  % zero-padded 6-digit hex
  ^^^^^^01d400% 𝐀   \bfA    Mathematical Bold Capital A
  ^^^^^^01d401% 𝐁   \bfB    Mathematical Bold Capital B
  ^^^^^^01d402% 𝐂   \bfC    Mathematical Bold Capital C
  ^^^^^^01d403% 𝐃   \bfD    Mathematical Bold Capital D
  ^^^^^^01d404% 𝐄   \bfE    Mathematical Bold Capital E
  ^^^^^^01d405% 𝐅   \bfF    Mathematical Bold Capital F
  ^^^^^^01d406% 𝐆   \bfG    Mathematical Bold Capital G
  ^^^^^^01d407% 𝐇   \bfH    Mathematical Bold Capital H
  ^^^^^^01d408% 𝐈   \bfI    Mathematical Bold Capital I
  ^^^^^^01d409% 𝐉   \bfJ    Mathematical Bold Capital J
  ^^^^^^01d40a% 𝐊   \bfK    Mathematical Bold Capital K
  ^^^^^^01d40b% 𝐋   \bfL    Mathematical Bold Capital L
  ^^^^^^01d40c% 𝐌   \bfM    Mathematical Bold Capital M
  ^^^^^^01d40d% 𝐍   \bfN    Mathematical Bold Capital N
  ^^^^^^01d40e% 𝐎   \bfO    Mathematical Bold Capital O
  ^^^^^^01d40f% 𝐏   \bfP    Mathematical Bold Capital P
  ^^^^^^01d410% 𝐐   \bfQ    Mathematical Bold Capital Q
  ^^^^^^01d411% 𝐑   \bfR    Mathematical Bold Capital R
  ^^^^^^01d412% 𝐒   \bfS    Mathematical Bold Capital S
  ^^^^^^01d413% 𝐓   \bfT    Mathematical Bold Capital T
  ^^^^^^01d414% 𝐔   \bfU    Mathematical Bold Capital U
  ^^^^^^01d415% 𝐕   \bfV    Mathematical Bold Capital V
  ^^^^^^01d416% 𝐖   \bfW    Mathematical Bold Capital W
  ^^^^^^01d417% 𝐗   \bfX    Mathematical Bold Capital X
  ^^^^^^01d418% 𝐘   \bfY    Mathematical Bold Capital Y
  ^^^^^^01d419% 𝐙   \bfZ    Mathematical Bold Capital Z
  ^^^^^^01d41a% 𝐚   \bfa    Mathematical Bold Small A
  ^^^^^^01d41b% 𝐛   \bfb    Mathematical Bold Small B
  ^^^^^^01d41c% 𝐜   \bfc    Mathematical Bold Small C
  ^^^^^^01d41d% 𝐝   \bfd    Mathematical Bold Small D
  ^^^^^^01d41e% 𝐞   \bfe    Mathematical Bold Small E
  ^^^^^^01d41f% 𝐟   \bff    Mathematical Bold Small F
  ^^^^^^01d420% 𝐠   \bfg    Mathematical Bold Small G
  ^^^^^^01d421% 𝐡   \bfh    Mathematical Bold Small H
  ^^^^^^01d422% 𝐢   \bfi    Mathematical Bold Small I
  ^^^^^^01d423% 𝐣   \bfj    Mathematical Bold Small J
  ^^^^^^01d424% 𝐤   \bfk    Mathematical Bold Small K
  ^^^^^^01d425% 𝐥   \bfl    Mathematical Bold Small L
  ^^^^^^01d426% 𝐦   \bfm    Mathematical Bold Small M
  ^^^^^^01d427% 𝐧   \bfn    Mathematical Bold Small N
  ^^^^^^01d428% 𝐨   \bfo    Mathematical Bold Small O
  ^^^^^^01d429% 𝐩   \bfp    Mathematical Bold Small P
  ^^^^^^01d42a% 𝐪   \bfq    Mathematical Bold Small Q
  ^^^^^^01d42b% 𝐫   \bfr    Mathematical Bold Small R
  ^^^^^^01d42c% 𝐬   \bfs    Mathematical Bold Small S
  ^^^^^^01d42d% 𝐭   \bft    Mathematical Bold Small T
  ^^^^^^01d42e% 𝐮   \bfu    Mathematical Bold Small U
  ^^^^^^01d42f% 𝐯   \bfv    Mathematical Bold Small V
  ^^^^^^01d430% 𝐰   \bfw    Mathematical Bold Small W
  ^^^^^^01d431% 𝐱   \bfx    Mathematical Bold Small X
  ^^^^^^01d432% 𝐲   \bfy    Mathematical Bold Small Y
  ^^^^^^01d433% 𝐳   \bfz    Mathematical Bold Small Z
  ^^^^^^01d434% 𝐴   \itA    Mathematical Italic Capital A
  ^^^^^^01d435% 𝐵   \itB    Mathematical Italic Capital B
  ^^^^^^01d436% 𝐶   \itC    Mathematical Italic Capital C
  ^^^^^^01d437% 𝐷   \itD    Mathematical Italic Capital D
  ^^^^^^01d438% 𝐸   \itE    Mathematical Italic Capital E
  ^^^^^^01d439% 𝐹   \itF    Mathematical Italic Capital F
  ^^^^^^01d43a% 𝐺   \itG    Mathematical Italic Capital G
  ^^^^^^01d43b% 𝐻   \itH    Mathematical Italic Capital H
  ^^^^^^01d43c% 𝐼   \itI    Mathematical Italic Capital I
  ^^^^^^01d43d% 𝐽   \itJ    Mathematical Italic Capital J
  ^^^^^^01d43e% 𝐾   \itK    Mathematical Italic Capital K
  ^^^^^^01d43f% 𝐿   \itL    Mathematical Italic Capital L
  ^^^^^^01d440% 𝑀   \itM    Mathematical Italic Capital M
  ^^^^^^01d441% 𝑁   \itN    Mathematical Italic Capital N
  ^^^^^^01d442% 𝑂   \itO    Mathematical Italic Capital O
  ^^^^^^01d443% 𝑃   \itP    Mathematical Italic Capital P
  ^^^^^^01d444% 𝑄   \itQ    Mathematical Italic Capital Q
  ^^^^^^01d445% 𝑅   \itR    Mathematical Italic Capital R
  ^^^^^^01d446% 𝑆   \itS    Mathematical Italic Capital S
  ^^^^^^01d447% 𝑇   \itT    Mathematical Italic Capital T
  ^^^^^^01d448% 𝑈   \itU    Mathematical Italic Capital U
  ^^^^^^01d449% 𝑉   \itV    Mathematical Italic Capital V
  ^^^^^^01d44a% 𝑊   \itW    Mathematical Italic Capital W
  ^^^^^^01d44b% 𝑋   \itX    Mathematical Italic Capital X
  ^^^^^^01d44c% 𝑌   \itY    Mathematical Italic Capital Y
  ^^^^^^01d44d% 𝑍   \itZ    Mathematical Italic Capital Z
  ^^^^^^01d44e% 𝑎   \ita    Mathematical Italic Small A
  ^^^^^^01d44f% 𝑏   \itb    Mathematical Italic Small B
  ^^^^^^01d450% 𝑐   \itc    Mathematical Italic Small C
  ^^^^^^01d451% 𝑑   \itd    Mathematical Italic Small D
  ^^^^^^01d452% 𝑒   \ite    Mathematical Italic Small E
  ^^^^^^01d453% 𝑓   \itf    Mathematical Italic Small F
  ^^^^^^01d454% 𝑔   \itg    Mathematical Italic Small G
  ^^^^^^01d456% 𝑖   \iti    Mathematical Italic Small I
  ^^^^^^01d457% 𝑗   \itj    Mathematical Italic Small J
  ^^^^^^01d458% 𝑘   \itk    Mathematical Italic Small K
  ^^^^^^01d459% 𝑙   \itl    Mathematical Italic Small L
  ^^^^^^01d45a% 𝑚   \itm    Mathematical Italic Small M
  ^^^^^^01d45b% 𝑛   \itn    Mathematical Italic Small N
  ^^^^^^01d45c% 𝑜   \ito    Mathematical Italic Small O
  ^^^^^^01d45d% 𝑝   \itp    Mathematical Italic Small P
  ^^^^^^01d45e% 𝑞   \itq    Mathematical Italic Small Q
  ^^^^^^01d45f% 𝑟   \itr    Mathematical Italic Small R
  ^^^^^^01d460% 𝑠   \its    Mathematical Italic Small S
  ^^^^^^01d461% 𝑡   \itt    Mathematical Italic Small T
  ^^^^^^01d462% 𝑢   \itu    Mathematical Italic Small U
  ^^^^^^01d463% 𝑣   \itv    Mathematical Italic Small V
  ^^^^^^01d464% 𝑤   \itw    Mathematical Italic Small W
  ^^^^^^01d465% 𝑥   \itx    Mathematical Italic Small X
  ^^^^^^01d466% 𝑦   \ity    Mathematical Italic Small Y
  ^^^^^^01d467% 𝑧   \itz    Mathematical Italic Small Z
  ^^^^^^01d468% 𝑨   \biA    Mathematical Bold Italic Capital A
  ^^^^^^01d469% 𝑩   \biB    Mathematical Bold Italic Capital B
  ^^^^^^01d46a% 𝑪   \biC    Mathematical Bold Italic Capital C
  ^^^^^^01d46b% 𝑫   \biD    Mathematical Bold Italic Capital D
  ^^^^^^01d46c% 𝑬   \biE    Mathematical Bold Italic Capital E
  ^^^^^^01d46d% 𝑭   \biF    Mathematical Bold Italic Capital F
  ^^^^^^01d46e% 𝑮   \biG    Mathematical Bold Italic Capital G
  ^^^^^^01d46f% 𝑯   \biH    Mathematical Bold Italic Capital H
  ^^^^^^01d470% 𝑰   \biI    Mathematical Bold Italic Capital I
  ^^^^^^01d471% 𝑱   \biJ    Mathematical Bold Italic Capital J
  ^^^^^^01d472% 𝑲   \biK    Mathematical Bold Italic Capital K
  ^^^^^^01d473% 𝑳   \biL    Mathematical Bold Italic Capital L
  ^^^^^^01d474% 𝑴   \biM    Mathematical Bold Italic Capital M
  ^^^^^^01d475% 𝑵   \biN    Mathematical Bold Italic Capital N
  ^^^^^^01d476% 𝑶   \biO    Mathematical Bold Italic Capital O
  ^^^^^^01d477% 𝑷   \biP    Mathematical Bold Italic Capital P
  ^^^^^^01d478% 𝑸   \biQ    Mathematical Bold Italic Capital Q
  ^^^^^^01d479% 𝑹   \biR    Mathematical Bold Italic Capital R
  ^^^^^^01d47a% 𝑺   \biS    Mathematical Bold Italic Capital S
  ^^^^^^01d47b% 𝑻   \biT    Mathematical Bold Italic Capital T
  ^^^^^^01d47c% 𝑼   \biU    Mathematical Bold Italic Capital U
  ^^^^^^01d47d% 𝑽   \biV    Mathematical Bold Italic Capital V
  ^^^^^^01d47e% 𝑾   \biW    Mathematical Bold Italic Capital W
  ^^^^^^01d47f% 𝑿   \biX    Mathematical Bold Italic Capital X
  ^^^^^^01d480% 𝒀   \biY    Mathematical Bold Italic Capital Y
  ^^^^^^01d481% 𝒁   \biZ    Mathematical Bold Italic Capital Z
  ^^^^^^01d482% 𝒂   \bia    Mathematical Bold Italic Small A
  ^^^^^^01d483% 𝒃   \bib    Mathematical Bold Italic Small B
  ^^^^^^01d484% 𝒄   \bic    Mathematical Bold Italic Small C
  ^^^^^^01d485% 𝒅   \bid    Mathematical Bold Italic Small D
  ^^^^^^01d486% 𝒆   \bie    Mathematical Bold Italic Small E
  ^^^^^^01d487% 𝒇   \bif    Mathematical Bold Italic Small F
  ^^^^^^01d488% 𝒈   \big    Mathematical Bold Italic Small G
  ^^^^^^01d489% 𝒉   \bih    Mathematical Bold Italic Small H
  ^^^^^^01d48a% 𝒊   \bii    Mathematical Bold Italic Small I
  ^^^^^^01d48b% 𝒋   \bij    Mathematical Bold Italic Small J
  ^^^^^^01d48c% 𝒌   \bik    Mathematical Bold Italic Small K
  ^^^^^^01d48d% 𝒍   \bil    Mathematical Bold Italic Small L
  ^^^^^^01d48e% 𝒎   \bim    Mathematical Bold Italic Small M
  ^^^^^^01d48f% 𝒏   \bin    Mathematical Bold Italic Small N
  ^^^^^^01d490% 𝒐   \bio    Mathematical Bold Italic Small O
  ^^^^^^01d491% 𝒑   \bip    Mathematical Bold Italic Small P
  ^^^^^^01d492% 𝒒   \biq    Mathematical Bold Italic Small Q
  ^^^^^^01d493% 𝒓   \bir    Mathematical Bold Italic Small R
  ^^^^^^01d494% 𝒔   \bis    Mathematical Bold Italic Small S
  ^^^^^^01d495% 𝒕   \bit    Mathematical Bold Italic Small T
  ^^^^^^01d496% 𝒖   \biu    Mathematical Bold Italic Small U
  ^^^^^^01d497% 𝒗   \biv    Mathematical Bold Italic Small V
  ^^^^^^01d498% 𝒘   \biw    Mathematical Bold Italic Small W
  ^^^^^^01d499% 𝒙   \bix    Mathematical Bold Italic Small X
  ^^^^^^01d49a% 𝒚   \biy    Mathematical Bold Italic Small Y
  ^^^^^^01d49b% 𝒛   \biz    Mathematical Bold Italic Small Z
  ^^^^^^01d49c% 𝒜   \scrA   Mathematical Script Capital A
  ^^^^^^01d49e% 𝒞   \scrC   Mathematical Script Capital C
  ^^^^^^01d49f% 𝒟   \scrD   Mathematical Script Capital D
  ^^^^^^01d4a2% 𝒢   \scrG   Mathematical Script Capital G
  ^^^^^^01d4a5% 𝒥   \scrJ   Mathematical Script Capital J
  ^^^^^^01d4a6% 𝒦   \scrK   Mathematical Script Capital K
  ^^^^^^01d4a9% 𝒩   \scrN   Mathematical Script Capital N
  ^^^^^^01d4aa% 𝒪   \scrO   Mathematical Script Capital O
  ^^^^^^01d4ab% 𝒫   \scrP   Mathematical Script Capital P
  ^^^^^^01d4ac% 𝒬   \scrQ   Mathematical Script Capital Q
  ^^^^^^01d4ae% 𝒮   \scrS   Mathematical Script Capital S
  ^^^^^^01d4af% 𝒯   \scrT   Mathematical Script Capital T
  ^^^^^^01d4b0% 𝒰   \scrU   Mathematical Script Capital U
  ^^^^^^01d4b1% 𝒱   \scrV   Mathematical Script Capital V
  ^^^^^^01d4b2% 𝒲   \scrW   Mathematical Script Capital W
  ^^^^^^01d4b3% 𝒳   \scrX   Mathematical Script Capital X
  ^^^^^^01d4b4% 𝒴   \scrY   Mathematical Script Capital Y
  ^^^^^^01d4b5% 𝒵   \scrZ   Mathematical Script Capital Z
  ^^^^^^01d4b6% 𝒶   \scra   Mathematical Script Small A
  ^^^^^^01d4b7% 𝒷   \scrb   Mathematical Script Small B
  ^^^^^^01d4b8% 𝒸   \scrc   Mathematical Script Small C
  ^^^^^^01d4b9% 𝒹   \scrd   Mathematical Script Small D
  ^^^^^^01d4bb% 𝒻   \scrf   Mathematical Script Small F
  ^^^^^^01d4bd% 𝒽   \scrh   Mathematical Script Small H
  ^^^^^^01d4be% 𝒾   \scri   Mathematical Script Small I
  ^^^^^^01d4bf% 𝒿   \scrj   Mathematical Script Small J
  ^^^^^^01d4c0% 𝓀   \scrk   Mathematical Script Small K
  ^^^^^^01d4c1% 𝓁   \scrl   Mathematical Script Small L
  ^^^^^^01d4c2% 𝓂   \scrm   Mathematical Script Small M
  ^^^^^^01d4c3% 𝓃   \scrn   Mathematical Script Small N
  ^^^^^^01d4c5% 𝓅   \scrp   Mathematical Script Small P
  ^^^^^^01d4c6% 𝓆   \scrq   Mathematical Script Small Q
  ^^^^^^01d4c7% 𝓇   \scrr   Mathematical Script Small R
  ^^^^^^01d4c8% 𝓈   \scrs   Mathematical Script Small S
  ^^^^^^01d4c9% 𝓉   \scrt   Mathematical Script Small T
  ^^^^^^01d4ca% 𝓊   \scru   Mathematical Script Small U
  ^^^^^^01d4cb% 𝓋   \scrv   Mathematical Script Small V
  ^^^^^^01d4cc% 𝓌   \scrw   Mathematical Script Small W
  ^^^^^^01d4cd% 𝓍   \scrx   Mathematical Script Small X
  ^^^^^^01d4ce% 𝓎   \scry   Mathematical Script Small Y
  ^^^^^^01d4cf% 𝓏   \scrz   Mathematical Script Small Z
  ^^^^^^01d4d0% 𝓐   \bscrA  Mathematical Bold Script Capital A
  ^^^^^^01d4d1% 𝓑   \bscrB  Mathematical Bold Script Capital B
  ^^^^^^01d4d2% 𝓒   \bscrC  Mathematical Bold Script Capital C
  ^^^^^^01d4d3% 𝓓   \bscrD  Mathematical Bold Script Capital D
  ^^^^^^01d4d4% 𝓔   \bscrE  Mathematical Bold Script Capital E
  ^^^^^^01d4d5% 𝓕   \bscrF  Mathematical Bold Script Capital F
  ^^^^^^01d4d6% 𝓖   \bscrG  Mathematical Bold Script Capital G
  ^^^^^^01d4d7% 𝓗   \bscrH  Mathematical Bold Script Capital H
  ^^^^^^01d4d8% 𝓘   \bscrI  Mathematical Bold Script Capital I
  ^^^^^^01d4d9% 𝓙   \bscrJ  Mathematical Bold Script Capital J
  ^^^^^^01d4da% 𝓚   \bscrK  Mathematical Bold Script Capital K
  ^^^^^^01d4db% 𝓛   \bscrL  Mathematical Bold Script Capital L
  ^^^^^^01d4dc% 𝓜   \bscrM  Mathematical Bold Script Capital M
  ^^^^^^01d4dd% 𝓝   \bscrN  Mathematical Bold Script Capital N
  ^^^^^^01d4de% 𝓞   \bscrO  Mathematical Bold Script Capital O
  ^^^^^^01d4df% 𝓟   \bscrP  Mathematical Bold Script Capital P
  ^^^^^^01d4e0% 𝓠   \bscrQ  Mathematical Bold Script Capital Q
  ^^^^^^01d4e1% 𝓡   \bscrR  Mathematical Bold Script Capital R
  ^^^^^^01d4e2% 𝓢   \bscrS  Mathematical Bold Script Capital S
  ^^^^^^01d4e3% 𝓣   \bscrT  Mathematical Bold Script Capital T
  ^^^^^^01d4e4% 𝓤   \bscrU  Mathematical Bold Script Capital U
  ^^^^^^01d4e5% 𝓥   \bscrV  Mathematical Bold Script Capital V
  ^^^^^^01d4e6% 𝓦   \bscrW  Mathematical Bold Script Capital W
  ^^^^^^01d4e7% 𝓧   \bscrX  Mathematical Bold Script Capital X
  ^^^^^^01d4e8% 𝓨   \bscrY  Mathematical Bold Script Capital Y
  ^^^^^^01d4e9% 𝓩   \bscrZ  Mathematical Bold Script Capital Z
  ^^^^^^01d4ea% 𝓪   \bscra  Mathematical Bold Script Small A
  ^^^^^^01d4eb% 𝓫   \bscrb  Mathematical Bold Script Small B
  ^^^^^^01d4ec% 𝓬   \bscrc  Mathematical Bold Script Small C
  ^^^^^^01d4ed% 𝓭   \bscrd  Mathematical Bold Script Small D
  ^^^^^^01d4ee% 𝓮   \bscre  Mathematical Bold Script Small E
  ^^^^^^01d4ef% 𝓯   \bscrf  Mathematical Bold Script Small F
  ^^^^^^01d4f0% 𝓰   \bscrg  Mathematical Bold Script Small G
  ^^^^^^01d4f1% 𝓱   \bscrh  Mathematical Bold Script Small H
  ^^^^^^01d4f2% 𝓲   \bscri  Mathematical Bold Script Small I
  ^^^^^^01d4f3% 𝓳   \bscrj  Mathematical Bold Script Small J
  ^^^^^^01d4f4% 𝓴   \bscrk  Mathematical Bold Script Small K
  ^^^^^^01d4f5% 𝓵   \bscrl  Mathematical Bold Script Small L
  ^^^^^^01d4f6% 𝓶   \bscrm  Mathematical Bold Script Small M
  ^^^^^^01d4f7% 𝓷   \bscrn  Mathematical Bold Script Small N
  ^^^^^^01d4f8% 𝓸   \bscro  Mathematical Bold Script Small O
  ^^^^^^01d4f9% 𝓹   \bscrp  Mathematical Bold Script Small P
  ^^^^^^01d4fa% 𝓺   \bscrq  Mathematical Bold Script Small Q
  ^^^^^^01d4fb% 𝓻   \bscrr  Mathematical Bold Script Small R
  ^^^^^^01d4fc% 𝓼   \bscrs  Mathematical Bold Script Small S
  ^^^^^^01d4fd% 𝓽   \bscrt  Mathematical Bold Script Small T
  ^^^^^^01d4fe% 𝓾   \bscru  Mathematical Bold Script Small U
  ^^^^^^01d4ff% 𝓿   \bscrv  Mathematical Bold Script Small V
  ^^^^^^01d500% 𝔀   \bscrw  Mathematical Bold Script Small W
  ^^^^^^01d501% 𝔁   \bscrx  Mathematical Bold Script Small X
  ^^^^^^01d502% 𝔂   \bscry  Mathematical Bold Script Small Y
  ^^^^^^01d503% 𝔃   \bscrz  Mathematical Bold Script Small Z
  ^^^^^^01d504% 𝔄   \frakA  Mathematical Fraktur Capital A
  ^^^^^^01d505% 𝔅   \frakB  Mathematical Fraktur Capital B
  ^^^^^^01d507% 𝔇   \frakD  Mathematical Fraktur Capital D
  ^^^^^^01d508% 𝔈   \frakE  Mathematical Fraktur Capital E
  ^^^^^^01d509% 𝔉   \frakF  Mathematical Fraktur Capital F
  ^^^^^^01d50a% 𝔊   \frakG  Mathematical Fraktur Capital G
  ^^^^^^01d50d% 𝔍   \frakJ  Mathematical Fraktur Capital J
  ^^^^^^01d50e% 𝔎   \frakK  Mathematical Fraktur Capital K
  ^^^^^^01d50f% 𝔏   \frakL  Mathematical Fraktur Capital L
  ^^^^^^01d510% 𝔐   \frakM  Mathematical Fraktur Capital M
  ^^^^^^01d511% 𝔑   \frakN  Mathematical Fraktur Capital N
  ^^^^^^01d512% 𝔒   \frakO  Mathematical Fraktur Capital O
  ^^^^^^01d513% 𝔓   \frakP  Mathematical Fraktur Capital P
  ^^^^^^01d514% 𝔔   \frakQ  Mathematical Fraktur Capital Q
  ^^^^^^01d516% 𝔖   \frakS  Mathematical Fraktur Capital S
  ^^^^^^01d517% 𝔗   \frakT  Mathematical Fraktur Capital T
  ^^^^^^01d518% 𝔘   \frakU  Mathematical Fraktur Capital U
  ^^^^^^01d519% 𝔙   \frakV  Mathematical Fraktur Capital V
  ^^^^^^01d51a% 𝔚   \frakW  Mathematical Fraktur Capital W
  ^^^^^^01d51b% 𝔛   \frakX  Mathematical Fraktur Capital X
  ^^^^^^01d51c% 𝔜   \frakY  Mathematical Fraktur Capital Y
  ^^^^^^01d51e% 𝔞   \fraka  Mathematical Fraktur Small A
  ^^^^^^01d51f% 𝔟   \frakb  Mathematical Fraktur Small B
  ^^^^^^01d520% 𝔠   \frakc  Mathematical Fraktur Small C
  ^^^^^^01d521% 𝔡   \frakd  Mathematical Fraktur Small D
  ^^^^^^01d522% 𝔢   \frake  Mathematical Fraktur Small E
  ^^^^^^01d523% 𝔣   \frakf  Mathematical Fraktur Small F
  ^^^^^^01d524% 𝔤   \frakg  Mathematical Fraktur Small G
  ^^^^^^01d525% 𝔥   \frakh  Mathematical Fraktur Small H
  ^^^^^^01d526% 𝔦   \fraki  Mathematical Fraktur Small I
  ^^^^^^01d527% 𝔧   \frakj  Mathematical Fraktur Small J
  ^^^^^^01d528% 𝔨   \frakk  Mathematical Fraktur Small K
  ^^^^^^01d529% 𝔩   \frakl  Mathematical Fraktur Small L
  ^^^^^^01d52a% 𝔪   \frakm  Mathematical Fraktur Small M
  ^^^^^^01d52b% 𝔫   \frakn  Mathematical Fraktur Small N
  ^^^^^^01d52c% 𝔬   \frako  Mathematical Fraktur Small O
  ^^^^^^01d52d% 𝔭   \frakp  Mathematical Fraktur Small P
  ^^^^^^01d52e% 𝔮   \frakq  Mathematical Fraktur Small Q
  ^^^^^^01d52f% 𝔯   \frakr  Mathematical Fraktur Small R
  ^^^^^^01d530% 𝔰   \fraks  Mathematical Fraktur Small S
  ^^^^^^01d531% 𝔱   \frakt  Mathematical Fraktur Small T
  ^^^^^^01d532% 𝔲   \fraku  Mathematical Fraktur Small U
  ^^^^^^01d533% 𝔳   \frakv  Mathematical Fraktur Small V
  ^^^^^^01d534% 𝔴   \frakw  Mathematical Fraktur Small W
  ^^^^^^01d535% 𝔵   \frakx  Mathematical Fraktur Small X
  ^^^^^^01d536% 𝔶   \fraky  Mathematical Fraktur Small Y
  ^^^^^^01d537% 𝔷   \frakz  Mathematical Fraktur Small Z
  ^^^^^^01d538% 𝔸   \bbA    Mathematical Double-Struck Capital A
  ^^^^^^01d539% 𝔹   \bbB    Mathematical Double-Struck Capital B
  ^^^^^^01d53b% 𝔻   \bbD    Mathematical Double-Struck Capital D
  ^^^^^^01d53c% 𝔼   \bbE    Mathematical Double-Struck Capital E
  ^^^^^^01d53d% 𝔽   \bbF    Mathematical Double-Struck Capital F
  ^^^^^^01d53e% 𝔾   \bbG    Mathematical Double-Struck Capital G
  ^^^^^^01d540% 𝕀   \bbI    Mathematical Double-Struck Capital I
  ^^^^^^01d541% 𝕁   \bbJ    Mathematical Double-Struck Capital J
  ^^^^^^01d542% 𝕂   \bbK    Mathematical Double-Struck Capital K
  ^^^^^^01d543% 𝕃   \bbL    Mathematical Double-Struck Capital L
  ^^^^^^01d544% 𝕄   \bbM    Mathematical Double-Struck Capital M
  ^^^^^^01d546% 𝕆   \bbO    Mathematical Double-Struck Capital O
  ^^^^^^01d54a% 𝕊   \bbS    Mathematical Double-Struck Capital S
  ^^^^^^01d54b% 𝕋   \bbT    Mathematical Double-Struck Capital T
  ^^^^^^01d54c% 𝕌   \bbU    Mathematical Double-Struck Capital U
  ^^^^^^01d54d% 𝕍   \bbV    Mathematical Double-Struck Capital V
  ^^^^^^01d54e% 𝕎   \bbW    Mathematical Double-Struck Capital W
  ^^^^^^01d54f% 𝕏   \bbX    Mathematical Double-Struck Capital X
  ^^^^^^01d550% 𝕐   \bbY    Mathematical Double-Struck Capital Y
  ^^^^^^01d552% 𝕒   \bba    Mathematical Double-Struck Small A
  ^^^^^^01d553% 𝕓   \bbb    Mathematical Double-Struck Small B
  ^^^^^^01d554% 𝕔   \bbc    Mathematical Double-Struck Small C
  ^^^^^^01d555% 𝕕   \bbd    Mathematical Double-Struck Small D
  ^^^^^^01d556% 𝕖   \bbe    Mathematical Double-Struck Small E
  ^^^^^^01d557% 𝕗   \bbf    Mathematical Double-Struck Small F
  ^^^^^^01d558% 𝕘   \bbg    Mathematical Double-Struck Small G
  ^^^^^^01d559% 𝕙   \bbh    Mathematical Double-Struck Small H
  ^^^^^^01d55a% 𝕚   \bbi    Mathematical Double-Struck Small I
  ^^^^^^01d55b% 𝕛   \bbj    Mathematical Double-Struck Small J
  ^^^^^^01d55c% 𝕜   \bbk    Mathematical Double-Struck Small K
  ^^^^^^01d55d% 𝕝   \bbl    Mathematical Double-Struck Small L
  ^^^^^^01d55e% 𝕞   \bbm    Mathematical Double-Struck Small M
  ^^^^^^01d55f% 𝕟   \bbn    Mathematical Double-Struck Small N
  ^^^^^^01d560% 𝕠   \bbo    Mathematical Double-Struck Small O
  ^^^^^^01d561% 𝕡   \bbp    Mathematical Double-Struck Small P
  ^^^^^^01d562% 𝕢   \bbq    Mathematical Double-Struck Small Q
  ^^^^^^01d563% 𝕣   \bbr    Mathematical Double-Struck Small R
  ^^^^^^01d564% 𝕤   \bbs    Mathematical Double-Struck Small S
  ^^^^^^01d565% 𝕥   \bbt    Mathematical Double-Struck Small T
  ^^^^^^01d566% 𝕦   \bbu    Mathematical Double-Struck Small U
  ^^^^^^01d567% 𝕧   \bbv    Mathematical Double-Struck Small V
  ^^^^^^01d568% 𝕨   \bbw    Mathematical Double-Struck Small W
  ^^^^^^01d569% 𝕩   \bbx    Mathematical Double-Struck Small X
  ^^^^^^01d56a% 𝕪   \bby    Mathematical Double-Struck Small Y
  ^^^^^^01d56b% 𝕫   \bbz    Mathematical Double-Struck Small Z
  ^^^^^^01d56c% 𝕬   \bfrakA Mathematical Bold Fraktur Capital A
  ^^^^^^01d56d% 𝕭   \bfrakB Mathematical Bold Fraktur Capital B
  ^^^^^^01d56e% 𝕮   \bfrakC Mathematical Bold Fraktur Capital C
  ^^^^^^01d56f% 𝕯   \bfrakD Mathematical Bold Fraktur Capital D
  ^^^^^^01d570% 𝕰   \bfrakE Mathematical Bold Fraktur Capital E
  ^^^^^^01d571% 𝕱   \bfrakF Mathematical Bold Fraktur Capital F
  ^^^^^^01d572% 𝕲   \bfrakG Mathematical Bold Fraktur Capital G
  ^^^^^^01d573% 𝕳   \bfrakH Mathematical Bold Fraktur Capital H
  ^^^^^^01d574% 𝕴   \bfrakI Mathematical Bold Fraktur Capital I
  ^^^^^^01d575% 𝕵   \bfrakJ Mathematical Bold Fraktur Capital J
  ^^^^^^01d576% 𝕶   \bfrakK Mathematical Bold Fraktur Capital K
  ^^^^^^01d577% 𝕷   \bfrakL Mathematical Bold Fraktur Capital L
  ^^^^^^01d578% 𝕸   \bfrakM Mathematical Bold Fraktur Capital M
  ^^^^^^01d579% 𝕹   \bfrakN Mathematical Bold Fraktur Capital N
  ^^^^^^01d57a% 𝕺   \bfrakO Mathematical Bold Fraktur Capital O
  ^^^^^^01d57b% 𝕻   \bfrakP Mathematical Bold Fraktur Capital P
  ^^^^^^01d57c% 𝕼   \bfrakQ Mathematical Bold Fraktur Capital Q
  ^^^^^^01d57d% 𝕽   \bfrakR Mathematical Bold Fraktur Capital R
  ^^^^^^01d57e% 𝕾   \bfrakS Mathematical Bold Fraktur Capital S
  ^^^^^^01d57f% 𝕿   \bfrakT Mathematical Bold Fraktur Capital T
  ^^^^^^01d580% 𝖀   \bfrakU Mathematical Bold Fraktur Capital U
  ^^^^^^01d581% 𝖁   \bfrakV Mathematical Bold Fraktur Capital V
  ^^^^^^01d582% 𝖂   \bfrakW Mathematical Bold Fraktur Capital W
  ^^^^^^01d583% 𝖃   \bfrakX Mathematical Bold Fraktur Capital X
  ^^^^^^01d584% 𝖄   \bfrakY Mathematical Bold Fraktur Capital Y
  ^^^^^^01d585% 𝖅   \bfrakZ Mathematical Bold Fraktur Capital Z
  ^^^^^^01d586% 𝖆   \bfraka Mathematical Bold Fraktur Small A
  ^^^^^^01d587% 𝖇   \bfrakb Mathematical Bold Fraktur Small B
  ^^^^^^01d588% 𝖈   \bfrakc Mathematical Bold Fraktur Small C
  ^^^^^^01d589% 𝖉   \bfrakd Mathematical Bold Fraktur Small D
  ^^^^^^01d58a% 𝖊   \bfrake Mathematical Bold Fraktur Small E
  ^^^^^^01d58b% 𝖋   \bfrakf Mathematical Bold Fraktur Small F
  ^^^^^^01d58c% 𝖌   \bfrakg Mathematical Bold Fraktur Small G
  ^^^^^^01d58d% 𝖍   \bfrakh Mathematical Bold Fraktur Small H
  ^^^^^^01d58e% 𝖎   \bfraki Mathematical Bold Fraktur Small I
  ^^^^^^01d58f% 𝖏   \bfrakj Mathematical Bold Fraktur Small J
  ^^^^^^01d590% 𝖐   \bfrakk Mathematical Bold Fraktur Small K
  ^^^^^^01d591% 𝖑   \bfrakl Mathematical Bold Fraktur Small L
  ^^^^^^01d592% 𝖒   \bfrakm Mathematical Bold Fraktur Small M
  ^^^^^^01d593% 𝖓   \bfrakn Mathematical Bold Fraktur Small N
  ^^^^^^01d594% 𝖔   \bfrako Mathematical Bold Fraktur Small O
  ^^^^^^01d595% 𝖕   \bfrakp Mathematical Bold Fraktur Small P
  ^^^^^^01d596% 𝖖   \bfrakq Mathematical Bold Fraktur Small Q
  ^^^^^^01d597% 𝖗   \bfrakr Mathematical Bold Fraktur Small R
  ^^^^^^01d598% 𝖘   \bfraks Mathematical Bold Fraktur Small S
  ^^^^^^01d599% 𝖙   \bfrakt Mathematical Bold Fraktur Small T
  ^^^^^^01d59a% 𝖚   \bfraku Mathematical Bold Fraktur Small U
  ^^^^^^01d59b% 𝖛   \bfrakv Mathematical Bold Fraktur Small V
  ^^^^^^01d59c% 𝖜   \bfrakw Mathematical Bold Fraktur Small W
  ^^^^^^01d59d% 𝖝   \bfrakx Mathematical Bold Fraktur Small X
  ^^^^^^01d59e% 𝖞   \bfraky Mathematical Bold Fraktur Small Y
  ^^^^^^01d59f% 𝖟   \bfrakz Mathematical Bold Fraktur Small Z
  ^^^^^^01d5a0% 𝖠   \sansA  Mathematical Sans-Serif Capital A
  ^^^^^^01d5a1% 𝖡   \sansB  Mathematical Sans-Serif Capital B
  ^^^^^^01d5a2% 𝖢   \sansC  Mathematical Sans-Serif Capital C
  ^^^^^^01d5a3% 𝖣   \sansD  Mathematical Sans-Serif Capital D
  ^^^^^^01d5a4% 𝖤   \sansE  Mathematical Sans-Serif Capital E
  ^^^^^^01d5a5% 𝖥   \sansF  Mathematical Sans-Serif Capital F
  ^^^^^^01d5a6% 𝖦   \sansG  Mathematical Sans-Serif Capital G
  ^^^^^^01d5a7% 𝖧   \sansH  Mathematical Sans-Serif Capital H
  ^^^^^^01d5a8% 𝖨   \sansI  Mathematical Sans-Serif Capital I
  ^^^^^^01d5a9% 𝖩   \sansJ  Mathematical Sans-Serif Capital J
  ^^^^^^01d5aa% 𝖪   \sansK  Mathematical Sans-Serif Capital K
  ^^^^^^01d5ab% 𝖫   \sansL  Mathematical Sans-Serif Capital L
  ^^^^^^01d5ac% 𝖬   \sansM  Mathematical Sans-Serif Capital M
  ^^^^^^01d5ad% 𝖭   \sansN  Mathematical Sans-Serif Capital N
  ^^^^^^01d5ae% 𝖮   \sansO  Mathematical Sans-Serif Capital O
  ^^^^^^01d5af% 𝖯   \sansP  Mathematical Sans-Serif Capital P
  ^^^^^^01d5b0% 𝖰   \sansQ  Mathematical Sans-Serif Capital Q
  ^^^^^^01d5b1% 𝖱   \sansR  Mathematical Sans-Serif Capital R
  ^^^^^^01d5b2% 𝖲   \sansS  Mathematical Sans-Serif Capital S
  ^^^^^^01d5b3% 𝖳   \sansT  Mathematical Sans-Serif Capital T
  ^^^^^^01d5b4% 𝖴   \sansU  Mathematical Sans-Serif Capital U
  ^^^^^^01d5b5% 𝖵   \sansV  Mathematical Sans-Serif Capital V
  ^^^^^^01d5b6% 𝖶   \sansW  Mathematical Sans-Serif Capital W
  ^^^^^^01d5b7% 𝖷   \sansX  Mathematical Sans-Serif Capital X
  ^^^^^^01d5b8% 𝖸   \sansY  Mathematical Sans-Serif Capital Y
  ^^^^^^01d5b9% 𝖹   \sansZ  Mathematical Sans-Serif Capital Z
  ^^^^^^01d5ba% 𝖺   \sansa  Mathematical Sans-Serif Small A
  ^^^^^^01d5bb% 𝖻   \sansb  Mathematical Sans-Serif Small B
  ^^^^^^01d5bc% 𝖼   \sansc  Mathematical Sans-Serif Small C
  ^^^^^^01d5bd% 𝖽   \sansd  Mathematical Sans-Serif Small D
  ^^^^^^01d5be% 𝖾   \sanse  Mathematical Sans-Serif Small E
  ^^^^^^01d5bf% 𝖿   \sansf  Mathematical Sans-Serif Small F
  ^^^^^^01d5c0% 𝗀   \sansg  Mathematical Sans-Serif Small G
  ^^^^^^01d5c1% 𝗁   \sansh  Mathematical Sans-Serif Small H
  ^^^^^^01d5c2% 𝗂   \sansi  Mathematical Sans-Serif Small I
  ^^^^^^01d5c3% 𝗃   \sansj  Mathematical Sans-Serif Small J
  ^^^^^^01d5c4% 𝗄   \sansk  Mathematical Sans-Serif Small K
  ^^^^^^01d5c5% 𝗅   \sansl  Mathematical Sans-Serif Small L
  ^^^^^^01d5c6% 𝗆   \sansm  Mathematical Sans-Serif Small M
  ^^^^^^01d5c7% 𝗇   \sansn  Mathematical Sans-Serif Small N
  ^^^^^^01d5c8% 𝗈   \sanso  Mathematical Sans-Serif Small O
  ^^^^^^01d5c9% 𝗉   \sansp  Mathematical Sans-Serif Small P
  ^^^^^^01d5ca% 𝗊   \sansq  Mathematical Sans-Serif Small Q
  ^^^^^^01d5cb% 𝗋   \sansr  Mathematical Sans-Serif Small R
  ^^^^^^01d5cc% 𝗌   \sanss  Mathematical Sans-Serif Small S
  ^^^^^^01d5cd% 𝗍   \sanst  Mathematical Sans-Serif Small T
  ^^^^^^01d5ce% 𝗎   \sansu  Mathematical Sans-Serif Small U
  ^^^^^^01d5cf% 𝗏   \sansv  Mathematical Sans-Serif Small V
  ^^^^^^01d5d0% 𝗐   \sansw  Mathematical Sans-Serif Small W
  ^^^^^^01d5d1% 𝗑   \sansx  Mathematical Sans-Serif Small X
  ^^^^^^01d5d2% 𝗒   \sansy  Mathematical Sans-Serif Small Y
  ^^^^^^01d5d3% 𝗓   \sansz  Mathematical Sans-Serif Small Z
  ^^^^^^01d5d4% 𝗔   \bsansA Mathematical Sans-Serif Bold Capital A
  ^^^^^^01d5d5% 𝗕   \bsansB Mathematical Sans-Serif Bold Capital B
  ^^^^^^01d5d6% 𝗖   \bsansC Mathematical Sans-Serif Bold Capital C
  ^^^^^^01d5d7% 𝗗   \bsansD Mathematical Sans-Serif Bold Capital D
  ^^^^^^01d5d8% 𝗘   \bsansE Mathematical Sans-Serif Bold Capital E
  ^^^^^^01d5d9% 𝗙   \bsansF Mathematical Sans-Serif Bold Capital F
  ^^^^^^01d5da% 𝗚   \bsansG Mathematical Sans-Serif Bold Capital G
  ^^^^^^01d5db% 𝗛   \bsansH Mathematical Sans-Serif Bold Capital H
  ^^^^^^01d5dc% 𝗜   \bsansI Mathematical Sans-Serif Bold Capital I
  ^^^^^^01d5dd% 𝗝   \bsansJ Mathematical Sans-Serif Bold Capital J
  ^^^^^^01d5de% 𝗞   \bsansK Mathematical Sans-Serif Bold Capital K
  ^^^^^^01d5df% 𝗟   \bsansL Mathematical Sans-Serif Bold Capital L
  ^^^^^^01d5e0% 𝗠   \bsansM Mathematical Sans-Serif Bold Capital M
  ^^^^^^01d5e1% 𝗡   \bsansN Mathematical Sans-Serif Bold Capital N
  ^^^^^^01d5e2% 𝗢   \bsansO Mathematical Sans-Serif Bold Capital O
  ^^^^^^01d5e3% 𝗣   \bsansP Mathematical Sans-Serif Bold Capital P
  ^^^^^^01d5e4% 𝗤   \bsansQ Mathematical Sans-Serif Bold Capital Q
  ^^^^^^01d5e5% 𝗥   \bsansR Mathematical Sans-Serif Bold Capital R
  ^^^^^^01d5e6% 𝗦   \bsansS Mathematical Sans-Serif Bold Capital S
  ^^^^^^01d5e7% 𝗧   \bsansT Mathematical Sans-Serif Bold Capital T
  ^^^^^^01d5e8% 𝗨   \bsansU Mathematical Sans-Serif Bold Capital U
  ^^^^^^01d5e9% 𝗩   \bsansV Mathematical Sans-Serif Bold Capital V
  ^^^^^^01d5ea% 𝗪   \bsansW Mathematical Sans-Serif Bold Capital W
  ^^^^^^01d5eb% 𝗫   \bsansX Mathematical Sans-Serif Bold Capital X
  ^^^^^^01d5ec% 𝗬   \bsansY Mathematical Sans-Serif Bold Capital Y
  ^^^^^^01d5ed% 𝗭   \bsansZ Mathematical Sans-Serif Bold Capital Z
  ^^^^^^01d5ee% 𝗮   \bsansa Mathematical Sans-Serif Bold Small A
  ^^^^^^01d5ef% 𝗯   \bsansb Mathematical Sans-Serif Bold Small B
  ^^^^^^01d5f0% 𝗰   \bsansc Mathematical Sans-Serif Bold Small C
  ^^^^^^01d5f1% 𝗱   \bsansd Mathematical Sans-Serif Bold Small D
  ^^^^^^01d5f2% 𝗲   \bsanse Mathematical Sans-Serif Bold Small E
  ^^^^^^01d5f3% 𝗳   \bsansf Mathematical Sans-Serif Bold Small F
  ^^^^^^01d5f4% 𝗴   \bsansg Mathematical Sans-Serif Bold Small G
  ^^^^^^01d5f5% 𝗵   \bsansh Mathematical Sans-Serif Bold Small H
  ^^^^^^01d5f6% 𝗶   \bsansi Mathematical Sans-Serif Bold Small I
  ^^^^^^01d5f7% 𝗷   \bsansj Mathematical Sans-Serif Bold Small J
  ^^^^^^01d5f8% 𝗸   \bsansk Mathematical Sans-Serif Bold Small K
  ^^^^^^01d5f9% 𝗹   \bsansl Mathematical Sans-Serif Bold Small L
  ^^^^^^01d5fa% 𝗺   \bsansm Mathematical Sans-Serif Bold Small M
  ^^^^^^01d5fb% 𝗻   \bsansn Mathematical Sans-Serif Bold Small N
  ^^^^^^01d5fc% 𝗼   \bsanso Mathematical Sans-Serif Bold Small O
  ^^^^^^01d5fd% 𝗽   \bsansp Mathematical Sans-Serif Bold Small P
  ^^^^^^01d5fe% 𝗾   \bsansq Mathematical Sans-Serif Bold Small Q
  ^^^^^^01d5ff% 𝗿   \bsansr Mathematical Sans-Serif Bold Small R
  ^^^^^^01d600% 𝘀   \bsanss Mathematical Sans-Serif Bold Small S
  ^^^^^^01d601% 𝘁   \bsanst Mathematical Sans-Serif Bold Small T
  ^^^^^^01d602% 𝘂   \bsansu Mathematical Sans-Serif Bold Small U
  ^^^^^^01d603% 𝘃   \bsansv Mathematical Sans-Serif Bold Small V
  ^^^^^^01d604% 𝘄   \bsansw Mathematical Sans-Serif Bold Small W
  ^^^^^^01d605% 𝘅   \bsansx Mathematical Sans-Serif Bold Small X
  ^^^^^^01d606% 𝘆   \bsansy Mathematical Sans-Serif Bold Small Y
  ^^^^^^01d607% 𝘇   \bsansz Mathematical Sans-Serif Bold Small Z
  ^^^^^^01d608% 𝘈   \isansA Mathematical Sans-Serif Italic Capital A
  ^^^^^^01d609% 𝘉   \isansB Mathematical Sans-Serif Italic Capital B
  ^^^^^^01d60a% 𝘊   \isansC Mathematical Sans-Serif Italic Capital C
  ^^^^^^01d60b% 𝘋   \isansD Mathematical Sans-Serif Italic Capital D
  ^^^^^^01d60c% 𝘌   \isansE Mathematical Sans-Serif Italic Capital E
  ^^^^^^01d60d% 𝘍   \isansF Mathematical Sans-Serif Italic Capital F
  ^^^^^^01d60e% 𝘎   \isansG Mathematical Sans-Serif Italic Capital G
  ^^^^^^01d60f% 𝘏   \isansH Mathematical Sans-Serif Italic Capital H
  ^^^^^^01d610% 𝘐   \isansI Mathematical Sans-Serif Italic Capital I
  ^^^^^^01d611% 𝘑   \isansJ Mathematical Sans-Serif Italic Capital J
  ^^^^^^01d612% 𝘒   \isansK Mathematical Sans-Serif Italic Capital K
  ^^^^^^01d613% 𝘓   \isansL Mathematical Sans-Serif Italic Capital L
  ^^^^^^01d614% 𝘔   \isansM Mathematical Sans-Serif Italic Capital M
  ^^^^^^01d615% 𝘕   \isansN Mathematical Sans-Serif Italic Capital N
  ^^^^^^01d616% 𝘖   \isansO Mathematical Sans-Serif Italic Capital O
  ^^^^^^01d617% 𝘗   \isansP Mathematical Sans-Serif Italic Capital P
  ^^^^^^01d618% 𝘘   \isansQ Mathematical Sans-Serif Italic Capital Q
  ^^^^^^01d619% 𝘙   \isansR Mathematical Sans-Serif Italic Capital R
  ^^^^^^01d61a% 𝘚   \isansS Mathematical Sans-Serif Italic Capital S
  ^^^^^^01d61b% 𝘛   \isansT Mathematical Sans-Serif Italic Capital T
  ^^^^^^01d61c% 𝘜   \isansU Mathematical Sans-Serif Italic Capital U
  ^^^^^^01d61d% 𝘝   \isansV Mathematical Sans-Serif Italic Capital V
  ^^^^^^01d61e% 𝘞   \isansW Mathematical Sans-Serif Italic Capital W
  ^^^^^^01d61f% 𝘟   \isansX Mathematical Sans-Serif Italic Capital X
  ^^^^^^01d620% 𝘠   \isansY Mathematical Sans-Serif Italic Capital Y
  ^^^^^^01d621% 𝘡   \isansZ Mathematical Sans-Serif Italic Capital Z
  ^^^^^^01d622% 𝘢   \isansa Mathematical Sans-Serif Italic Small A
  ^^^^^^01d623% 𝘣   \isansb Mathematical Sans-Serif Italic Small B
  ^^^^^^01d624% 𝘤   \isansc Mathematical Sans-Serif Italic Small C
  ^^^^^^01d625% 𝘥   \isansd Mathematical Sans-Serif Italic Small D
  ^^^^^^01d626% 𝘦   \isanse Mathematical Sans-Serif Italic Small E
  ^^^^^^01d627% 𝘧   \isansf Mathematical Sans-Serif Italic Small F
  ^^^^^^01d628% 𝘨   \isansg Mathematical Sans-Serif Italic Small G
  ^^^^^^01d629% 𝘩   \isansh Mathematical Sans-Serif Italic Small H
  ^^^^^^01d62a% 𝘪   \isansi Mathematical Sans-Serif Italic Small I
  ^^^^^^01d62b% 𝘫   \isansj Mathematical Sans-Serif Italic Small J
  ^^^^^^01d62c% 𝘬   \isansk Mathematical Sans-Serif Italic Small K
  ^^^^^^01d62d% 𝘭   \isansl Mathematical Sans-Serif Italic Small L
  ^^^^^^01d62e% 𝘮   \isansm Mathematical Sans-Serif Italic Small M
  ^^^^^^01d62f% 𝘯   \isansn Mathematical Sans-Serif Italic Small N
  ^^^^^^01d630% 𝘰   \isanso Mathematical Sans-Serif Italic Small O
  ^^^^^^01d631% 𝘱   \isansp Mathematical Sans-Serif Italic Small P
  ^^^^^^01d632% 𝘲   \isansq Mathematical Sans-Serif Italic Small Q
  ^^^^^^01d633% 𝘳   \isansr Mathematical Sans-Serif Italic Small R
  ^^^^^^01d634% 𝘴   \isanss Mathematical Sans-Serif Italic Small S
  ^^^^^^01d635% 𝘵   \isanst Mathematical Sans-Serif Italic Small T
  ^^^^^^01d636% 𝘶   \isansu Mathematical Sans-Serif Italic Small U
  ^^^^^^01d637% 𝘷   \isansv Mathematical Sans-Serif Italic Small V
  ^^^^^^01d638% 𝘸   \isansw Mathematical Sans-Serif Italic Small W
  ^^^^^^01d639% 𝘹   \isansx Mathematical Sans-Serif Italic Small X
  ^^^^^^01d63a% 𝘺   \isansy Mathematical Sans-Serif Italic Small Y
  ^^^^^^01d63b% 𝘻   \isansz Mathematical Sans-Serif Italic Small Z
  ^^^^^^01d63c% 𝘼   \bisansA    Mathematical Sans-Serif Bold Italic Capital A
  ^^^^^^01d63d% 𝘽   \bisansB    Mathematical Sans-Serif Bold Italic Capital B
  ^^^^^^01d63e% 𝘾   \bisansC    Mathematical Sans-Serif Bold Italic Capital C
  ^^^^^^01d63f% 𝘿   \bisansD    Mathematical Sans-Serif Bold Italic Capital D
  ^^^^^^01d640% 𝙀   \bisansE    Mathematical Sans-Serif Bold Italic Capital E
  ^^^^^^01d641% 𝙁   \bisansF    Mathematical Sans-Serif Bold Italic Capital F
  ^^^^^^01d642% 𝙂   \bisansG    Mathematical Sans-Serif Bold Italic Capital G
  ^^^^^^01d643% 𝙃   \bisansH    Mathematical Sans-Serif Bold Italic Capital H
  ^^^^^^01d644% 𝙄   \bisansI    Mathematical Sans-Serif Bold Italic Capital I
  ^^^^^^01d645% 𝙅   \bisansJ    Mathematical Sans-Serif Bold Italic Capital J
  ^^^^^^01d646% 𝙆   \bisansK    Mathematical Sans-Serif Bold Italic Capital K
  ^^^^^^01d647% 𝙇   \bisansL    Mathematical Sans-Serif Bold Italic Capital L
  ^^^^^^01d648% 𝙈   \bisansM    Mathematical Sans-Serif Bold Italic Capital M
  ^^^^^^01d649% 𝙉   \bisansN    Mathematical Sans-Serif Bold Italic Capital N
  ^^^^^^01d64a% 𝙊   \bisansO    Mathematical Sans-Serif Bold Italic Capital O
  ^^^^^^01d64b% 𝙋   \bisansP    Mathematical Sans-Serif Bold Italic Capital P
  ^^^^^^01d64c% 𝙌   \bisansQ    Mathematical Sans-Serif Bold Italic Capital Q
  ^^^^^^01d64d% 𝙍   \bisansR    Mathematical Sans-Serif Bold Italic Capital R
  ^^^^^^01d64e% 𝙎   \bisansS    Mathematical Sans-Serif Bold Italic Capital S
  ^^^^^^01d64f% 𝙏   \bisansT    Mathematical Sans-Serif Bold Italic Capital T
  ^^^^^^01d650% 𝙐   \bisansU    Mathematical Sans-Serif Bold Italic Capital U
  ^^^^^^01d651% 𝙑   \bisansV    Mathematical Sans-Serif Bold Italic Capital V
  ^^^^^^01d652% 𝙒   \bisansW    Mathematical Sans-Serif Bold Italic Capital W
  ^^^^^^01d653% 𝙓   \bisansX    Mathematical Sans-Serif Bold Italic Capital X
  ^^^^^^01d654% 𝙔   \bisansY    Mathematical Sans-Serif Bold Italic Capital Y
  ^^^^^^01d655% 𝙕   \bisansZ    Mathematical Sans-Serif Bold Italic Capital Z
  ^^^^^^01d656% 𝙖   \bisansa    Mathematical Sans-Serif Bold Italic Small A
  ^^^^^^01d657% 𝙗   \bisansb    Mathematical Sans-Serif Bold Italic Small B
  ^^^^^^01d658% 𝙘   \bisansc    Mathematical Sans-Serif Bold Italic Small C
  ^^^^^^01d659% 𝙙   \bisansd    Mathematical Sans-Serif Bold Italic Small D
  ^^^^^^01d65a% 𝙚   \bisanse    Mathematical Sans-Serif Bold Italic Small E
  ^^^^^^01d65b% 𝙛   \bisansf    Mathematical Sans-Serif Bold Italic Small F
  ^^^^^^01d65c% 𝙜   \bisansg    Mathematical Sans-Serif Bold Italic Small G
  ^^^^^^01d65d% 𝙝   \bisansh    Mathematical Sans-Serif Bold Italic Small H
  ^^^^^^01d65e% 𝙞   \bisansi    Mathematical Sans-Serif Bold Italic Small I
  ^^^^^^01d65f% 𝙟   \bisansj    Mathematical Sans-Serif Bold Italic Small J
  ^^^^^^01d660% 𝙠   \bisansk    Mathematical Sans-Serif Bold Italic Small K
  ^^^^^^01d661% 𝙡   \bisansl    Mathematical Sans-Serif Bold Italic Small L
  ^^^^^^01d662% 𝙢   \bisansm    Mathematical Sans-Serif Bold Italic Small M
  ^^^^^^01d663% 𝙣   \bisansn    Mathematical Sans-Serif Bold Italic Small N
  ^^^^^^01d664% 𝙤   \bisanso    Mathematical Sans-Serif Bold Italic Small O
  ^^^^^^01d665% 𝙥   \bisansp    Mathematical Sans-Serif Bold Italic Small P
  ^^^^^^01d666% 𝙦   \bisansq    Mathematical Sans-Serif Bold Italic Small Q
  ^^^^^^01d667% 𝙧   \bisansr    Mathematical Sans-Serif Bold Italic Small R
  ^^^^^^01d668% 𝙨   \bisanss    Mathematical Sans-Serif Bold Italic Small S
  ^^^^^^01d669% 𝙩   \bisanst    Mathematical Sans-Serif Bold Italic Small T
  ^^^^^^01d66a% 𝙪   \bisansu    Mathematical Sans-Serif Bold Italic Small U
  ^^^^^^01d66b% 𝙫   \bisansv    Mathematical Sans-Serif Bold Italic Small V
  ^^^^^^01d66c% 𝙬   \bisansw    Mathematical Sans-Serif Bold Italic Small W
  ^^^^^^01d66d% 𝙭   \bisansx    Mathematical Sans-Serif Bold Italic Small X
  ^^^^^^01d66e% 𝙮   \bisansy    Mathematical Sans-Serif Bold Italic Small Y
  ^^^^^^01d66f% 𝙯   \bisansz    Mathematical Sans-Serif Bold Italic Small Z
  ^^^^^^01d670% 𝙰   \ttA    Mathematical Monospace Capital A
  ^^^^^^01d671% 𝙱   \ttB    Mathematical Monospace Capital B
  ^^^^^^01d672% 𝙲   \ttC    Mathematical Monospace Capital C
  ^^^^^^01d673% 𝙳   \ttD    Mathematical Monospace Capital D
  ^^^^^^01d674% 𝙴   \ttE    Mathematical Monospace Capital E
  ^^^^^^01d675% 𝙵   \ttF    Mathematical Monospace Capital F
  ^^^^^^01d676% 𝙶   \ttG    Mathematical Monospace Capital G
  ^^^^^^01d677% 𝙷   \ttH    Mathematical Monospace Capital H
  ^^^^^^01d678% 𝙸   \ttI    Mathematical Monospace Capital I
  ^^^^^^01d679% 𝙹   \ttJ    Mathematical Monospace Capital J
  ^^^^^^01d67a% 𝙺   \ttK    Mathematical Monospace Capital K
  ^^^^^^01d67b% 𝙻   \ttL    Mathematical Monospace Capital L
  ^^^^^^01d67c% 𝙼   \ttM    Mathematical Monospace Capital M
  ^^^^^^01d67d% 𝙽   \ttN    Mathematical Monospace Capital N
  ^^^^^^01d67e% 𝙾   \ttO    Mathematical Monospace Capital O
  ^^^^^^01d67f% 𝙿   \ttP    Mathematical Monospace Capital P
  ^^^^^^01d680% 𝚀   \ttQ    Mathematical Monospace Capital Q
  ^^^^^^01d681% 𝚁   \ttR    Mathematical Monospace Capital R
  ^^^^^^01d682% 𝚂   \ttS    Mathematical Monospace Capital S
  ^^^^^^01d683% 𝚃   \ttT    Mathematical Monospace Capital T
  ^^^^^^01d684% 𝚄   \ttU    Mathematical Monospace Capital U
  ^^^^^^01d685% 𝚅   \ttV    Mathematical Monospace Capital V
  ^^^^^^01d686% 𝚆   \ttW    Mathematical Monospace Capital W
  ^^^^^^01d687% 𝚇   \ttX    Mathematical Monospace Capital X
  ^^^^^^01d688% 𝚈   \ttY    Mathematical Monospace Capital Y
  ^^^^^^01d689% 𝚉   \ttZ    Mathematical Monospace Capital Z
  ^^^^^^01d68a% 𝚊   \tta    Mathematical Monospace Small A
  ^^^^^^01d68b% 𝚋   \ttb    Mathematical Monospace Small B
  ^^^^^^01d68c% 𝚌   \ttc    Mathematical Monospace Small C
  ^^^^^^01d68d% 𝚍   \ttd    Mathematical Monospace Small D
  ^^^^^^01d68e% 𝚎   \tte    Mathematical Monospace Small E
  ^^^^^^01d68f% 𝚏   \ttf    Mathematical Monospace Small F
  ^^^^^^01d690% 𝚐   \ttg    Mathematical Monospace Small G
  ^^^^^^01d691% 𝚑   \tth    Mathematical Monospace Small H
  ^^^^^^01d692% 𝚒   \tti    Mathematical Monospace Small I
  ^^^^^^01d693% 𝚓   \ttj    Mathematical Monospace Small J
  ^^^^^^01d694% 𝚔   \ttk    Mathematical Monospace Small K
  ^^^^^^01d695% 𝚕   \ttl    Mathematical Monospace Small L
  ^^^^^^01d696% 𝚖   \ttm    Mathematical Monospace Small M
  ^^^^^^01d697% 𝚗   \ttn    Mathematical Monospace Small N
  ^^^^^^01d698% 𝚘   \tto    Mathematical Monospace Small O
  ^^^^^^01d699% 𝚙   \ttp    Mathematical Monospace Small P
  ^^^^^^01d69a% 𝚚   \ttq    Mathematical Monospace Small Q
  ^^^^^^01d69b% 𝚛   \ttr    Mathematical Monospace Small R
  ^^^^^^01d69c% 𝚜   \tts    Mathematical Monospace Small S
  ^^^^^^01d69d% 𝚝   \ttt    Mathematical Monospace Small T
  ^^^^^^01d69e% 𝚞   \ttu    Mathematical Monospace Small U
  ^^^^^^01d69f% 𝚟   \ttv    Mathematical Monospace Small V
  ^^^^^^01d6a0% 𝚠   \ttw    Mathematical Monospace Small W
  ^^^^^^01d6a1% 𝚡   \ttx    Mathematical Monospace Small X
  ^^^^^^01d6a2% 𝚢   \tty    Mathematical Monospace Small Y
  ^^^^^^01d6a3% 𝚣   \ttz    Mathematical Monospace Small Z
  ^^^^^^01d6a4% 𝚤   \itimath    Mathematical Italic Small Dotless I
  ^^^^^^01d6a5% 𝚥   \itjmath    Mathematical Italic Small Dotless J
  ^^^^^^01d6a8% 𝚨   \bfAlpha    Mathematical Bold Capital Alpha
  ^^^^^^01d6a9% 𝚩   \bfBeta Mathematical Bold Capital Beta
  ^^^^^^01d6aa% 𝚪   \bfGamma    Mathematical Bold Capital Gamma
  ^^^^^^01d6ab% 𝚫   \bfDelta    Mathematical Bold Capital Delta
  ^^^^^^01d6ac% 𝚬   \bfEpsilon  Mathematical Bold Capital Epsilon
  ^^^^^^01d6ad% 𝚭   \bfZeta Mathematical Bold Capital Zeta
  ^^^^^^01d6ae% 𝚮   \bfEta  Mathematical Bold Capital Eta
  ^^^^^^01d6af% 𝚯   \bfTheta    Mathematical Bold Capital Theta
  ^^^^^^01d6b0% 𝚰   \bfIota Mathematical Bold Capital Iota
  ^^^^^^01d6b1% 𝚱   \bfKappa    Mathematical Bold Capital Kappa
  ^^^^^^01d6b2% 𝚲   \bfLambda   Mathematical Bold Capital Lamda
  ^^^^^^01d6b3% 𝚳   \bfMu   Mathematical Bold Capital Mu
  ^^^^^^01d6b4% 𝚴   \bfNu   Mathematical Bold Capital Nu
  ^^^^^^01d6b5% 𝚵   \bfXi   Mathematical Bold Capital Xi
  ^^^^^^01d6b6% 𝚶   \bfOmicron  Mathematical Bold Capital Omicron
  ^^^^^^01d6b7% 𝚷   \bfPi   Mathematical Bold Capital Pi
  ^^^^^^01d6b8% 𝚸   \bfRho  Mathematical Bold Capital Rho
  ^^^^^^01d6b9% 𝚹   \bfvarTheta Mathematical Bold Capital Theta Symbol
  ^^^^^^01d6ba% 𝚺   \bfSigma    Mathematical Bold Capital Sigma
  ^^^^^^01d6bb% 𝚻   \bfTau  Mathematical Bold Capital Tau
  ^^^^^^01d6bc% 𝚼   \bfUpsilon  Mathematical Bold Capital Upsilon
  ^^^^^^01d6bd% 𝚽   \bfPhi  Mathematical Bold Capital Phi
  ^^^^^^01d6be% 𝚾   \bfChi  Mathematical Bold Capital Chi
  ^^^^^^01d6bf% 𝚿   \bfPsi  Mathematical Bold Capital Psi
  ^^^^^^01d6c0% 𝛀   \bfOmega    Mathematical Bold Capital Omega
  ^^^^^^01d6c1% 𝛁   \bfnabla    Mathematical Bold Nabla
  ^^^^^^01d6c2% 𝛂   \bfalpha    Mathematical Bold Small Alpha
  ^^^^^^01d6c3% 𝛃   \bfbeta Mathematical Bold Small Beta
  ^^^^^^01d6c4% 𝛄   \bfgamma    Mathematical Bold Small Gamma
  ^^^^^^01d6c5% 𝛅   \bfdelta    Mathematical Bold Small Delta
  ^^^^^^01d6c6% 𝛆   \bfepsilon  Mathematical Bold Small Epsilon
  ^^^^^^01d6c7% 𝛇   \bfzeta Mathematical Bold Small Zeta
  ^^^^^^01d6c8% 𝛈   \bfeta  Mathematical Bold Small Eta
  ^^^^^^01d6c9% 𝛉   \bftheta    Mathematical Bold Small Theta
  ^^^^^^01d6ca% 𝛊   \bfiota Mathematical Bold Small Iota
  ^^^^^^01d6cb% 𝛋   \bfkappa    Mathematical Bold Small Kappa
  ^^^^^^01d6cc% 𝛌   \bflambda   Mathematical Bold Small Lamda
  ^^^^^^01d6cd% 𝛍   \bfmu   Mathematical Bold Small Mu
  ^^^^^^01d6ce% 𝛎   \bfnu   Mathematical Bold Small Nu
  ^^^^^^01d6cf% 𝛏   \bfxi   Mathematical Bold Small Xi
  ^^^^^^01d6d0% 𝛐   \bfomicron  Mathematical Bold Small Omicron
  ^^^^^^01d6d1% 𝛑   \bfpi   Mathematical Bold Small Pi
  ^^^^^^01d6d2% 𝛒   \bfrho  Mathematical Bold Small Rho
  ^^^^^^01d6d3% 𝛓   \bfvarsigma Mathematical Bold Small Final Sigma
  ^^^^^^01d6d4% 𝛔   \bfsigma    Mathematical Bold Small Sigma
  ^^^^^^01d6d5% 𝛕   \bftau  Mathematical Bold Small Tau
  ^^^^^^01d6d6% 𝛖   \bfupsilon  Mathematical Bold Small Upsilon
  ^^^^^^01d6d7% 𝛗   \bfvarphi   Mathematical Bold Small Phi
  ^^^^^^01d6d8% 𝛘   \bfchi  Mathematical Bold Small Chi
  ^^^^^^01d6d9% 𝛙   \bfpsi  Mathematical Bold Small Psi
  ^^^^^^01d6da% 𝛚   \bfomega    Mathematical Bold Small Omega
  ^^^^^^01d6db% 𝛛   \bfpartial  Mathematical Bold Partial Differential
  ^^^^^^01d6dc% 𝛜   \bfvarepsilon   Mathematical Bold Epsilon Symbol
  ^^^^^^01d6dd% 𝛝   \bfvartheta Mathematical Bold Theta Symbol
  ^^^^^^01d6de% 𝛞   \bfvarkappa Mathematical Bold Kappa Symbol
  ^^^^^^01d6df% 𝛟   \bfphi  Mathematical Bold Phi Symbol
  ^^^^^^01d6e0% 𝛠   \bfvarrho   Mathematical Bold Rho Symbol
  ^^^^^^01d6e1% 𝛡   \bfvarpi    Mathematical Bold Pi Symbol
  ^^^^^^01d6e2% 𝛢   \itAlpha    Mathematical Italic Capital Alpha
  ^^^^^^01d6e3% 𝛣   \itBeta Mathematical Italic Capital Beta
  ^^^^^^01d6e4% 𝛤   \itGamma    Mathematical Italic Capital Gamma
  ^^^^^^01d6e5% 𝛥   \itDelta    Mathematical Italic Capital Delta
  ^^^^^^01d6e6% 𝛦   \itEpsilon  Mathematical Italic Capital Epsilon
  ^^^^^^01d6e7% 𝛧   \itZeta Mathematical Italic Capital Zeta
  ^^^^^^01d6e8% 𝛨   \itEta  Mathematical Italic Capital Eta
  ^^^^^^01d6e9% 𝛩   \itTheta    Mathematical Italic Capital Theta
  ^^^^^^01d6ea% 𝛪   \itIota Mathematical Italic Capital Iota
  ^^^^^^01d6eb% 𝛫   \itKappa    Mathematical Italic Capital Kappa
  ^^^^^^01d6ec% 𝛬   \itLambda   Mathematical Italic Capital Lamda
  ^^^^^^01d6ed% 𝛭   \itMu   Mathematical Italic Capital Mu
  ^^^^^^01d6ee% 𝛮   \itNu   Mathematical Italic Capital Nu
  ^^^^^^01d6ef% 𝛯   \itXi   Mathematical Italic Capital Xi
  ^^^^^^01d6f0% 𝛰   \itOmicron  Mathematical Italic Capital Omicron
  ^^^^^^01d6f1% 𝛱   \itPi   Mathematical Italic Capital Pi
  ^^^^^^01d6f2% 𝛲   \itRho  Mathematical Italic Capital Rho
  ^^^^^^01d6f3% 𝛳   \itvarTheta Mathematical Italic Capital Theta Symbol
  ^^^^^^01d6f4% 𝛴   \itSigma    Mathematical Italic Capital Sigma
  ^^^^^^01d6f5% 𝛵   \itTau  Mathematical Italic Capital Tau
  ^^^^^^01d6f6% 𝛶   \itUpsilon  Mathematical Italic Capital Upsilon
  ^^^^^^01d6f7% 𝛷   \itPhi  Mathematical Italic Capital Phi
  ^^^^^^01d6f8% 𝛸   \itChi  Mathematical Italic Capital Chi
  ^^^^^^01d6f9% 𝛹   \itPsi  Mathematical Italic Capital Psi
  ^^^^^^01d6fa% 𝛺   \itOmega    Mathematical Italic Capital Omega
  ^^^^^^01d6fb% 𝛻   \itnabla    Mathematical Italic Nabla
  ^^^^^^01d6fc% 𝛼   \italpha    Mathematical Italic Small Alpha
  ^^^^^^01d6fd% 𝛽   \itbeta Mathematical Italic Small Beta
  ^^^^^^01d6fe% 𝛾   \itgamma    Mathematical Italic Small Gamma
  ^^^^^^01d6ff% 𝛿   \itdelta    Mathematical Italic Small Delta
  ^^^^^^01d700% 𝜀   \itepsilon  Mathematical Italic Small Epsilon
  ^^^^^^01d701% 𝜁   \itzeta Mathematical Italic Small Zeta
  ^^^^^^01d702% 𝜂   \iteta  Mathematical Italic Small Eta
  ^^^^^^01d703% 𝜃   \ittheta    Mathematical Italic Small Theta
  ^^^^^^01d704% 𝜄   \itiota Mathematical Italic Small Iota
  ^^^^^^01d705% 𝜅   \itkappa    Mathematical Italic Small Kappa
  ^^^^^^01d706% 𝜆   \itlambda   Mathematical Italic Small Lamda
  ^^^^^^01d707% 𝜇   \itmu   Mathematical Italic Small Mu
  ^^^^^^01d708% 𝜈   \itnu   Mathematical Italic Small Nu
  ^^^^^^01d709% 𝜉   \itxi   Mathematical Italic Small Xi
  ^^^^^^01d70a% 𝜊   \itomicron  Mathematical Italic Small Omicron
  ^^^^^^01d70b% 𝜋   \itpi   Mathematical Italic Small Pi
  ^^^^^^01d70c% 𝜌   \itrho  Mathematical Italic Small Rho
  ^^^^^^01d70d% 𝜍   \itvarsigma Mathematical Italic Small Final Sigma
  ^^^^^^01d70e% 𝜎   \itsigma    Mathematical Italic Small Sigma
  ^^^^^^01d70f% 𝜏   \ittau  Mathematical Italic Small Tau
  ^^^^^^01d710% 𝜐   \itupsilon  Mathematical Italic Small Upsilon
  ^^^^^^01d711% 𝜑   \itphi  Mathematical Italic Small Phi
  ^^^^^^01d712% 𝜒   \itchi  Mathematical Italic Small Chi
  ^^^^^^01d713% 𝜓   \itpsi  Mathematical Italic Small Psi
  ^^^^^^01d714% 𝜔   \itomega    Mathematical Italic Small Omega
  ^^^^^^01d715% 𝜕   \itpartial  Mathematical Italic Partial Differential
  ^^^^^^01d716% 𝜖   \itvarepsilon   Mathematical Italic Epsilon Symbol
  ^^^^^^01d717% 𝜗   \itvartheta Mathematical Italic Theta Symbol
  ^^^^^^01d718% 𝜘   \itvarkappa Mathematical Italic Kappa Symbol
  ^^^^^^01d719% 𝜙   \itvarphi   Mathematical Italic Phi Symbol
  ^^^^^^01d71a% 𝜚   \itvarrho   Mathematical Italic Rho Symbol
  ^^^^^^01d71b% 𝜛   \itvarpi    Mathematical Italic Pi Symbol
  ^^^^^^01d71c% 𝜜   \biAlpha    Mathematical Bold Italic Capital Alpha
  ^^^^^^01d71d% 𝜝   \biBeta Mathematical Bold Italic Capital Beta
  ^^^^^^01d71e% 𝜞   \biGamma    Mathematical Bold Italic Capital Gamma
  ^^^^^^01d71f% 𝜟   \biDelta    Mathematical Bold Italic Capital Delta
  ^^^^^^01d720% 𝜠   \biEpsilon  Mathematical Bold Italic Capital Epsilon
  ^^^^^^01d721% 𝜡   \biZeta Mathematical Bold Italic Capital Zeta
  ^^^^^^01d722% 𝜢   \biEta  Mathematical Bold Italic Capital Eta
  ^^^^^^01d723% 𝜣   \biTheta    Mathematical Bold Italic Capital Theta
  ^^^^^^01d724% 𝜤   \biIota Mathematical Bold Italic Capital Iota
  ^^^^^^01d725% 𝜥   \biKappa    Mathematical Bold Italic Capital Kappa
  ^^^^^^01d726% 𝜦   \biLambda   Mathematical Bold Italic Capital Lamda
  ^^^^^^01d727% 𝜧   \biMu   Mathematical Bold Italic Capital Mu
  ^^^^^^01d728% 𝜨   \biNu   Mathematical Bold Italic Capital Nu
  ^^^^^^01d729% 𝜩   \biXi   Mathematical Bold Italic Capital Xi
  ^^^^^^01d72a% 𝜪   \biOmicron  Mathematical Bold Italic Capital Omicron
  ^^^^^^01d72b% 𝜫   \biPi   Mathematical Bold Italic Capital Pi
  ^^^^^^01d72c% 𝜬   \biRho  Mathematical Bold Italic Capital Rho
  ^^^^^^01d72d% 𝜭   \bivarTheta Mathematical Bold Italic Capital Theta Symbol
  ^^^^^^01d72e% 𝜮   \biSigma    Mathematical Bold Italic Capital Sigma
  ^^^^^^01d72f% 𝜯   \biTau  Mathematical Bold Italic Capital Tau
  ^^^^^^01d730% 𝜰   \biUpsilon  Mathematical Bold Italic Capital Upsilon
  ^^^^^^01d731% 𝜱   \biPhi  Mathematical Bold Italic Capital Phi
  ^^^^^^01d732% 𝜲   \biChi  Mathematical Bold Italic Capital Chi
  ^^^^^^01d733% 𝜳   \biPsi  Mathematical Bold Italic Capital Psi
  ^^^^^^01d734% 𝜴   \biOmega    Mathematical Bold Italic Capital Omega
  ^^^^^^01d735% 𝜵   \binabla    Mathematical Bold Italic Nabla
  ^^^^^^01d736% 𝜶   \bialpha    Mathematical Bold Italic Small Alpha
  ^^^^^^01d737% 𝜷   \bibeta Mathematical Bold Italic Small Beta
  ^^^^^^01d738% 𝜸   \bigamma    Mathematical Bold Italic Small Gamma
  ^^^^^^01d739% 𝜹   \bidelta    Mathematical Bold Italic Small Delta
  ^^^^^^01d73a% 𝜺   \biepsilon  Mathematical Bold Italic Small Epsilon
  ^^^^^^01d73b% 𝜻   \bizeta Mathematical Bold Italic Small Zeta
  ^^^^^^01d73c% 𝜼   \bieta  Mathematical Bold Italic Small Eta
  ^^^^^^01d73d% 𝜽   \bitheta    Mathematical Bold Italic Small Theta
  ^^^^^^01d73e% 𝜾   \biiota Mathematical Bold Italic Small Iota
  ^^^^^^01d73f% 𝜿   \bikappa    Mathematical Bold Italic Small Kappa
  ^^^^^^01d740% 𝝀   \bilambda   Mathematical Bold Italic Small Lamda
  ^^^^^^01d741% 𝝁   \bimu   Mathematical Bold Italic Small Mu
  ^^^^^^01d742% 𝝂   \binu   Mathematical Bold Italic Small Nu
  ^^^^^^01d743% 𝝃   \bixi   Mathematical Bold Italic Small Xi
  ^^^^^^01d744% 𝝄   \biomicron  Mathematical Bold Italic Small Omicron
  ^^^^^^01d745% 𝝅   \bipi   Mathematical Bold Italic Small Pi
  ^^^^^^01d746% 𝝆   \birho  Mathematical Bold Italic Small Rho
  ^^^^^^01d747% 𝝇   \bivarsigma Mathematical Bold Italic Small Final Sigma
  ^^^^^^01d748% 𝝈   \bisigma    Mathematical Bold Italic Small Sigma
  ^^^^^^01d749% 𝝉   \bitau  Mathematical Bold Italic Small Tau
  ^^^^^^01d74a% 𝝊   \biupsilon  Mathematical Bold Italic Small Upsilon
  ^^^^^^01d74b% 𝝋   \biphi  Mathematical Bold Italic Small Phi
  ^^^^^^01d74c% 𝝌   \bichi  Mathematical Bold Italic Small Chi
  ^^^^^^01d74d% 𝝍   \bipsi  Mathematical Bold Italic Small Psi
  ^^^^^^01d74e% 𝝎   \biomega    Mathematical Bold Italic Small Omega
  ^^^^^^01d74f% 𝝏   \bipartial  Mathematical Bold Italic Partial Differential
  ^^^^^^01d750% 𝝐   \bivarepsilon   Mathematical Bold Italic Epsilon Symbol
  ^^^^^^01d751% 𝝑   \bivartheta Mathematical Bold Italic Theta Symbol
  ^^^^^^01d752% 𝝒   \bivarkappa Mathematical Bold Italic Kappa Symbol
  ^^^^^^01d753% 𝝓   \bivarphi   Mathematical Bold Italic Phi Symbol
  ^^^^^^01d754% 𝝔   \bivarrho   Mathematical Bold Italic Rho Symbol
  ^^^^^^01d755% 𝝕   \bivarpi    Mathematical Bold Italic Pi Symbol
  ^^^^^^01d756% 𝝖   \bsansAlpha Mathematical Sans-Serif Bold Capital Alpha
  ^^^^^^01d757% 𝝗   \bsansBeta  Mathematical Sans-Serif Bold Capital Beta
  ^^^^^^01d758% 𝝘   \bsansGamma Mathematical Sans-Serif Bold Capital Gamma
  ^^^^^^01d759% 𝝙   \bsansDelta Mathematical Sans-Serif Bold Capital Delta
  ^^^^^^01d75a% 𝝚   \bsansEpsilon   Mathematical Sans-Serif Bold Capital Epsilon
  ^^^^^^01d75b% 𝝛   \bsansZeta  Mathematical Sans-Serif Bold Capital Zeta
  ^^^^^^01d75c% 𝝜   \bsansEta   Mathematical Sans-Serif Bold Capital Eta
  ^^^^^^01d75d% 𝝝   \bsansTheta Mathematical Sans-Serif Bold Capital Theta
  ^^^^^^01d75e% 𝝞   \bsansIota  Mathematical Sans-Serif Bold Capital Iota
  ^^^^^^01d75f% 𝝟   \bsansKappa Mathematical Sans-Serif Bold Capital Kappa
  ^^^^^^01d760% 𝝠   \bsansLambda    Mathematical Sans-Serif Bold Capital Lamda
  ^^^^^^01d761% 𝝡   \bsansMu    Mathematical Sans-Serif Bold Capital Mu
  ^^^^^^01d762% 𝝢   \bsansNu    Mathematical Sans-Serif Bold Capital Nu
  ^^^^^^01d763% 𝝣   \bsansXi    Mathematical Sans-Serif Bold Capital Xi
  ^^^^^^01d764% 𝝤   \bsansOmicron   Mathematical Sans-Serif Bold Capital Omicron
  ^^^^^^01d765% 𝝥   \bsansPi    Mathematical Sans-Serif Bold Capital Pi
  ^^^^^^01d766% 𝝦   \bsansRho   Mathematical Sans-Serif Bold Capital Rho
  ^^^^^^01d767% 𝝧   \bsansvarTheta  Mathematical Sans-Serif Bold Capital Theta Symbol
  ^^^^^^01d768% 𝝨   \bsansSigma Mathematical Sans-Serif Bold Capital Sigma
  ^^^^^^01d769% 𝝩   \bsansTau   Mathematical Sans-Serif Bold Capital Tau
  ^^^^^^01d76a% 𝝪   \bsansUpsilon   Mathematical Sans-Serif Bold Capital Upsilon
  ^^^^^^01d76b% 𝝫   \bsansPhi   Mathematical Sans-Serif Bold Capital Phi
  ^^^^^^01d76c% 𝝬   \bsansChi   Mathematical Sans-Serif Bold Capital Chi
  ^^^^^^01d76d% 𝝭   \bsansPsi   Mathematical Sans-Serif Bold Capital Psi
  ^^^^^^01d76e% 𝝮   \bsansOmega Mathematical Sans-Serif Bold Capital Omega
  ^^^^^^01d76f% 𝝯   \bsansnabla Mathematical Sans-Serif Bold Nabla
  ^^^^^^01d770% 𝝰   \bsansalpha Mathematical Sans-Serif Bold Small Alpha
  ^^^^^^01d771% 𝝱   \bsansbeta  Mathematical Sans-Serif Bold Small Beta
  ^^^^^^01d772% 𝝲   \bsansgamma Mathematical Sans-Serif Bold Small Gamma
  ^^^^^^01d773% 𝝳   \bsansdelta Mathematical Sans-Serif Bold Small Delta
  ^^^^^^01d774% 𝝴   \bsansepsilon   Mathematical Sans-Serif Bold Small Epsilon
  ^^^^^^01d775% 𝝵   \bsanszeta  Mathematical Sans-Serif Bold Small Zeta
  ^^^^^^01d776% 𝝶   \bsanseta   Mathematical Sans-Serif Bold Small Eta
  ^^^^^^01d777% 𝝷   \bsanstheta Mathematical Sans-Serif Bold Small Theta
  ^^^^^^01d778% 𝝸   \bsansiota  Mathematical Sans-Serif Bold Small Iota
  ^^^^^^01d779% 𝝹   \bsanskappa Mathematical Sans-Serif Bold Small Kappa
  ^^^^^^01d77a% 𝝺   \bsanslambda    Mathematical Sans-Serif Bold Small Lamda
  ^^^^^^01d77b% 𝝻   \bsansmu    Mathematical Sans-Serif Bold Small Mu
  ^^^^^^01d77c% 𝝼   \bsansnu    Mathematical Sans-Serif Bold Small Nu
  ^^^^^^01d77d% 𝝽   \bsansxi    Mathematical Sans-Serif Bold Small Xi
  ^^^^^^01d77e% 𝝾   \bsansomicron   Mathematical Sans-Serif Bold Small Omicron
  ^^^^^^01d77f% 𝝿   \bsanspi    Mathematical Sans-Serif Bold Small Pi
  ^^^^^^01d780% 𝞀   \bsansrho   Mathematical Sans-Serif Bold Small Rho
  ^^^^^^01d781% 𝞁   \bsansvarsigma  Mathematical Sans-Serif Bold Small Final Sigma
  ^^^^^^01d782% 𝞂   \bsanssigma Mathematical Sans-Serif Bold Small Sigma
  ^^^^^^01d783% 𝞃   \bsanstau   Mathematical Sans-Serif Bold Small Tau
  ^^^^^^01d784% 𝞄   \bsansupsilon   Mathematical Sans-Serif Bold Small Upsilon
  ^^^^^^01d785% 𝞅   \bsansphi   Mathematical Sans-Serif Bold Small Phi
  ^^^^^^01d786% 𝞆   \bsanschi   Mathematical Sans-Serif Bold Small Chi
  ^^^^^^01d787% 𝞇   \bsanspsi   Mathematical Sans-Serif Bold Small Psi
  ^^^^^^01d788% 𝞈   \bsansomega Mathematical Sans-Serif Bold Small Omega
  ^^^^^^01d789% 𝞉   \bsanspartial   Mathematical Sans-Serif Bold Partial Differential
  ^^^^^^01d78a% 𝞊   \bsansvarepsilon    Mathematical Sans-Serif Bold Epsilon Symbol
  ^^^^^^01d78b% 𝞋   \bsansvartheta  Mathematical Sans-Serif Bold Theta Symbol
  ^^^^^^01d78c% 𝞌   \bsansvarkappa  Mathematical Sans-Serif Bold Kappa Symbol
  ^^^^^^01d78d% 𝞍   \bsansvarphi    Mathematical Sans-Serif Bold Phi Symbol
  ^^^^^^01d78e% 𝞎   \bsansvarrho    Mathematical Sans-Serif Bold Rho Symbol
  ^^^^^^01d78f% 𝞏   \bsansvarpi Mathematical Sans-Serif Bold Pi Symbol
  ^^^^^^01d790% 𝞐   \bisansAlpha    Mathematical Sans-Serif Bold Italic Capital Alpha
  ^^^^^^01d791% 𝞑   \bisansBeta Mathematical Sans-Serif Bold Italic Capital Beta
  ^^^^^^01d792% 𝞒   \bisansGamma    Mathematical Sans-Serif Bold Italic Capital Gamma
  ^^^^^^01d793% 𝞓   \bisansDelta    Mathematical Sans-Serif Bold Italic Capital Delta
  ^^^^^^01d794% 𝞔   \bisansEpsilon  Mathematical Sans-Serif Bold Italic Capital Epsilon
  ^^^^^^01d795% 𝞕   \bisansZeta Mathematical Sans-Serif Bold Italic Capital Zeta
  ^^^^^^01d796% 𝞖   \bisansEta  Mathematical Sans-Serif Bold Italic Capital Eta
  ^^^^^^01d797% 𝞗   \bisansTheta    Mathematical Sans-Serif Bold Italic Capital Theta
  ^^^^^^01d798% 𝞘   \bisansIota Mathematical Sans-Serif Bold Italic Capital Iota
  ^^^^^^01d799% 𝞙   \bisansKappa    Mathematical Sans-Serif Bold Italic Capital Kappa
  ^^^^^^01d79a% 𝞚   \bisansLambda   Mathematical Sans-Serif Bold Italic Capital Lamda
  ^^^^^^01d79b% 𝞛   \bisansMu   Mathematical Sans-Serif Bold Italic Capital Mu
  ^^^^^^01d79c% 𝞜   \bisansNu   Mathematical Sans-Serif Bold Italic Capital Nu
  ^^^^^^01d79d% 𝞝   \bisansXi   Mathematical Sans-Serif Bold Italic Capital Xi
  ^^^^^^01d79e% 𝞞   \bisansOmicron  Mathematical Sans-Serif Bold Italic Capital Omicron
  ^^^^^^01d79f% 𝞟   \bisansPi   Mathematical Sans-Serif Bold Italic Capital Pi
  ^^^^^^01d7a0% 𝞠   \bisansRho  Mathematical Sans-Serif Bold Italic Capital Rho
  ^^^^^^01d7a1% 𝞡   \bisansvarTheta Mathematical Sans-Serif Bold Italic Capital Theta Symbol
  ^^^^^^01d7a2% 𝞢   \bisansSigma    Mathematical Sans-Serif Bold Italic Capital Sigma
  ^^^^^^01d7a3% 𝞣   \bisansTau  Mathematical Sans-Serif Bold Italic Capital Tau
  ^^^^^^01d7a4% 𝞤   \bisansUpsilon  Mathematical Sans-Serif Bold Italic Capital Upsilon
  ^^^^^^01d7a5% 𝞥   \bisansPhi  Mathematical Sans-Serif Bold Italic Capital Phi
  ^^^^^^01d7a6% 𝞦   \bisansChi  Mathematical Sans-Serif Bold Italic Capital Chi
  ^^^^^^01d7a7% 𝞧   \bisansPsi  Mathematical Sans-Serif Bold Italic Capital Psi
  ^^^^^^01d7a8% 𝞨   \bisansOmega    Mathematical Sans-Serif Bold Italic Capital Omega
  ^^^^^^01d7a9% 𝞩   \bisansnabla    Mathematical Sans-Serif Bold Italic Nabla
  ^^^^^^01d7aa% 𝞪   \bisansalpha    Mathematical Sans-Serif Bold Italic Small Alpha
  ^^^^^^01d7ab% 𝞫   \bisansbeta Mathematical Sans-Serif Bold Italic Small Beta
  ^^^^^^01d7ac% 𝞬   \bisansgamma    Mathematical Sans-Serif Bold Italic Small Gamma
  ^^^^^^01d7ad% 𝞭   \bisansdelta    Mathematical Sans-Serif Bold Italic Small Delta
  ^^^^^^01d7ae% 𝞮   \bisansepsilon  Mathematical Sans-Serif Bold Italic Small Epsilon
  ^^^^^^01d7af% 𝞯   \bisanszeta Mathematical Sans-Serif Bold Italic Small Zeta
  ^^^^^^01d7b0% 𝞰   \bisanseta  Mathematical Sans-Serif Bold Italic Small Eta
  ^^^^^^01d7b1% 𝞱   \bisanstheta    Mathematical Sans-Serif Bold Italic Small Theta
  ^^^^^^01d7b2% 𝞲   \bisansiota Mathematical Sans-Serif Bold Italic Small Iota
  ^^^^^^01d7b3% 𝞳   \bisanskappa    Mathematical Sans-Serif Bold Italic Small Kappa
  ^^^^^^01d7b4% 𝞴   \bisanslambda   Mathematical Sans-Serif Bold Italic Small Lamda
  ^^^^^^01d7b5% 𝞵   \bisansmu   Mathematical Sans-Serif Bold Italic Small Mu
  ^^^^^^01d7b6% 𝞶   \bisansnu   Mathematical Sans-Serif Bold Italic Small Nu
  ^^^^^^01d7b7% 𝞷   \bisansxi   Mathematical Sans-Serif Bold Italic Small Xi
  ^^^^^^01d7b8% 𝞸   \bisansomicron  Mathematical Sans-Serif Bold Italic Small Omicron
  ^^^^^^01d7b9% 𝞹   \bisanspi   Mathematical Sans-Serif Bold Italic Small Pi
  ^^^^^^01d7ba% 𝞺   \bisansrho  Mathematical Sans-Serif Bold Italic Small Rho
  ^^^^^^01d7bb% 𝞻   \bisansvarsigma Mathematical Sans-Serif Bold Italic Small Final Sigma
  ^^^^^^01d7bc% 𝞼   \bisanssigma    Mathematical Sans-Serif Bold Italic Small Sigma
  ^^^^^^01d7bd% 𝞽   \bisanstau  Mathematical Sans-Serif Bold Italic Small Tau
  ^^^^^^01d7be% 𝞾   \bisansupsilon  Mathematical Sans-Serif Bold Italic Small Upsilon
  ^^^^^^01d7bf% 𝞿   \bisansphi  Mathematical Sans-Serif Bold Italic Small Phi
  ^^^^^^01d7c0% 𝟀   \bisanschi  Mathematical Sans-Serif Bold Italic Small Chi
  ^^^^^^01d7c1% 𝟁   \bisanspsi  Mathematical Sans-Serif Bold Italic Small Psi
  ^^^^^^01d7c2% 𝟂   \bisansomega    Mathematical Sans-Serif Bold Italic Small Omega
  ^^^^^^01d7c3% 𝟃   \bisanspartial  Mathematical Sans-Serif Bold Italic Partial Differential
  ^^^^^^01d7c4% 𝟄   \bisansvarepsilon   Mathematical Sans-Serif Bold Italic Epsilon Symbol
  ^^^^^^01d7c5% 𝟅   \bisansvartheta Mathematical Sans-Serif Bold Italic Theta Symbol
  ^^^^^^01d7c6% 𝟆   \bisansvarkappa Mathematical Sans-Serif Bold Italic Kappa Symbol
  ^^^^^^01d7c7% 𝟇   \bisansvarphi   Mathematical Sans-Serif Bold Italic Phi Symbol
  ^^^^^^01d7c8% 𝟈   \bisansvarrho   Mathematical Sans-Serif Bold Italic Rho Symbol
  ^^^^^^01d7c9% 𝟉   \bisansvarpi    Mathematical Sans-Serif Bold Italic Pi Symbol
  ^^^^^^01d7ca% 𝟊   \bfDigamma  Mathematical Bold Capital Digamma
  ^^^^^^01d7cb% 𝟋   \bfdigamma  Mathematical Bold Small Digamma
  ^^^^^^01d7ce% 𝟎   \bfzero Mathematical Bold Digit Zero
  ^^^^^^01d7cf% 𝟏   \bfone  Mathematical Bold Digit One
  ^^^^^^01d7d0% 𝟐   \bftwo  Mathematical Bold Digit Two
  ^^^^^^01d7d1% 𝟑   \bfthree    Mathematical Bold Digit Three
  ^^^^^^01d7d2% 𝟒   \bffour Mathematical Bold Digit Four
  ^^^^^^01d7d3% 𝟓   \bffive Mathematical Bold Digit Five
  ^^^^^^01d7d4% 𝟔   \bfsix  Mathematical Bold Digit Six
  ^^^^^^01d7d5% 𝟕   \bfseven    Mathematical Bold Digit Seven
  ^^^^^^01d7d6% 𝟖   \bfeight    Mathematical Bold Digit Eight
  ^^^^^^01d7d7% 𝟗   \bfnine Mathematical Bold Digit Nine
  ^^^^^^01d7d8% 𝟘   \bbzero Mathematical Double-Struck Digit Zero
  ^^^^^^01d7d9% 𝟙   \bbone  Mathematical Double-Struck Digit One
  ^^^^^^01d7da% 𝟚   \bbtwo  Mathematical Double-Struck Digit Two
  ^^^^^^01d7db% 𝟛   \bbthree    Mathematical Double-Struck Digit Three
  ^^^^^^01d7dc% 𝟜   \bbfour Mathematical Double-Struck Digit Four
  ^^^^^^01d7dd% 𝟝   \bbfive Mathematical Double-Struck Digit Five
  ^^^^^^01d7de% 𝟞   \bbsix  Mathematical Double-Struck Digit Six
  ^^^^^^01d7df% 𝟟   \bbseven    Mathematical Double-Struck Digit Seven
  ^^^^^^01d7e0% 𝟠   \bbeight    Mathematical Double-Struck Digit Eight
  ^^^^^^01d7e1% 𝟡   \bbnine Mathematical Double-Struck Digit Nine
  ^^^^^^01d7e2% 𝟢   \sanszero   Mathematical Sans-Serif Digit Zero
  ^^^^^^01d7e3% 𝟣   \sansone    Mathematical Sans-Serif Digit One
  ^^^^^^01d7e4% 𝟤   \sanstwo    Mathematical Sans-Serif Digit Two
  ^^^^^^01d7e5% 𝟥   \sansthree  Mathematical Sans-Serif Digit Three
  ^^^^^^01d7e6% 𝟦   \sansfour   Mathematical Sans-Serif Digit Four
  ^^^^^^01d7e7% 𝟧   \sansfive   Mathematical Sans-Serif Digit Five
  ^^^^^^01d7e8% 𝟨   \sanssix    Mathematical Sans-Serif Digit Six
  ^^^^^^01d7e9% 𝟩   \sansseven  Mathematical Sans-Serif Digit Seven
  ^^^^^^01d7ea% 𝟪   \sanseight  Mathematical Sans-Serif Digit Eight
  ^^^^^^01d7eb% 𝟫   \sansnine   Mathematical Sans-Serif Digit Nine
  ^^^^^^01d7ec% 𝟬   \bsanszero  Mathematical Sans-Serif Bold Digit Zero
  ^^^^^^01d7ed% 𝟭   \bsansone   Mathematical Sans-Serif Bold Digit One
  ^^^^^^01d7ee% 𝟮   \bsanstwo   Mathematical Sans-Serif Bold Digit Two
  ^^^^^^01d7ef% 𝟯   \bsansthree Mathematical Sans-Serif Bold Digit Three
  ^^^^^^01d7f0% 𝟰   \bsansfour  Mathematical Sans-Serif Bold Digit Four
  ^^^^^^01d7f1% 𝟱   \bsansfive  Mathematical Sans-Serif Bold Digit Five
  ^^^^^^01d7f2% 𝟲   \bsanssix   Mathematical Sans-Serif Bold Digit Six
  ^^^^^^01d7f3% 𝟳   \bsansseven Mathematical Sans-Serif Bold Digit Seven
  ^^^^^^01d7f4% 𝟴   \bsanseight Mathematical Sans-Serif Bold Digit Eight
  ^^^^^^01d7f5% 𝟵   \bsansnine  Mathematical Sans-Serif Bold Digit Nine
  ^^^^^^01d7f6% 𝟶   \ttzero Mathematical Monospace Digit Zero
  ^^^^^^01d7f7% 𝟷   \ttone  Mathematical Monospace Digit One
  ^^^^^^01d7f8% 𝟸   \tttwo  Mathematical Monospace Digit Two
  ^^^^^^01d7f9% 𝟹   \ttthree    Mathematical Monospace Digit Three
  ^^^^^^01d7fa% 𝟺   \ttfour Mathematical Monospace Digit Four
  ^^^^^^01d7fb% 𝟻   \ttfive Mathematical Monospace Digit Five
  ^^^^^^01d7fc% 𝟼   \ttsix  Mathematical Monospace Digit Six
  ^^^^^^01d7fd% 𝟽   \ttseven    Mathematical Monospace Digit Seven
  ^^^^^^01d7fe% 𝟾   \tteight    Mathematical Monospace Digit Eight
  ^^^^^^01d7ff% 𝟿   \ttnine Mathematical Monospace Digit Nine
  % zero-padded 6-digit hex (emoji)
  ^^^^^^01f004% 🀄   \:mahjong:  Mahjong Tile Red Dragon
  ^^^^^^01f0cf% 🃏   \:black_joker:  Playing Card Black Joker
  ^^^^^^01f170% 🅰   \:a:    Negative Squared Latin Capital Letter A
  ^^^^^^01f171% 🅱   \:b:    Negative Squared Latin Capital Letter B
  ^^^^^^01f17e% 🅾   \:o2:   Negative Squared Latin Capital Letter O
  ^^^^^^01f17f% 🅿   \:parking:  Negative Squared Latin Capital Letter P
  ^^^^^^01f18e% 🆎   \:ab:   Negative Squared Ab
  ^^^^^^01f191% 🆑   \:cl:   Squared Cl
  ^^^^^^01f192% 🆒   \:cool: Squared Cool
  ^^^^^^01f193% 🆓   \:free: Squared Free
  ^^^^^^01f194% 🆔   \:id:   Squared Id
  ^^^^^^01f195% 🆕   \:new:  Squared New
  ^^^^^^01f196% 🆖   \:ng:   Squared Ng
  ^^^^^^01f197% 🆗   \:ok:   Squared Ok
  ^^^^^^01f198% 🆘   \:sos:  Squared Sos
  ^^^^^^01f199% 🆙   \:up:   Squared Up With Exclamation Mark
  ^^^^^^01f19a% 🆚   \:vs:   Squared Vs
  ^^^^^^01f201% 🈁   \:koko: Squared Katakana Koko
  ^^^^^^01f202% 🈂   \:sa:   Squared Katakana Sa
  ^^^^^^01f21a% 🈚   \:u7121:    Squared Cjk Unified Ideograph-7121
  ^^^^^^01f22f% 🈯   \:u6307:    Squared Cjk Unified Ideograph-6307
  ^^^^^^01f232% 🈲   \:u7981:    Squared Cjk Unified Ideograph-7981
  ^^^^^^01f233% 🈳   \:u7a7a:    Squared Cjk Unified Ideograph-7A7A
  ^^^^^^01f234% 🈴   \:u5408:    Squared Cjk Unified Ideograph-5408
  ^^^^^^01f235% 🈵   \:u6e80:    Squared Cjk Unified Ideograph-6E80
  ^^^^^^01f236% 🈶   \:u6709:    Squared Cjk Unified Ideograph-6709
  ^^^^^^01f237% 🈷   \:u6708:    Squared Cjk Unified Ideograph-6708
  ^^^^^^01f238% 🈸   \:u7533:    Squared Cjk Unified Ideograph-7533
  ^^^^^^01f239% 🈹   \:u5272:    Squared Cjk Unified Ideograph-5272
  ^^^^^^01f23a% 🈺   \:u55b6:    Squared Cjk Unified Ideograph-55B6
  ^^^^^^01f250% 🉐   \:ideograph_advantage:  Circled Ideograph Advantage
  ^^^^^^01f251% 🉑   \:accept:   Circled Ideograph Accept
  ^^^^^^01f300% 🌀   \:cyclone:  Cyclone
  ^^^^^^01f301% 🌁   \:foggy:    Foggy
  ^^^^^^01f302% 🌂   \:closed_umbrella:  Closed Umbrella
  ^^^^^^01f303% 🌃   \:night_with_stars: Night With Stars
  ^^^^^^01f304% 🌄   \:sunrise_over_mountains:   Sunrise Over Mountains
  ^^^^^^01f305% 🌅   \:sunrise:  Sunrise
  ^^^^^^01f306% 🌆   \:city_sunset:  Cityscape At Dusk
  ^^^^^^01f307% 🌇   \:city_sunrise: Sunset Over Buildings
  ^^^^^^01f308% 🌈   \:rainbow:  Rainbow
  ^^^^^^01f309% 🌉   \:bridge_at_night:  Bridge At Night
  ^^^^^^01f30a% 🌊   \:ocean:    Water Wave
  ^^^^^^01f30b% 🌋   \:volcano:  Volcano
  ^^^^^^01f30c% 🌌   \:milky_way:    Milky Way
  ^^^^^^01f30d% 🌍   \:earth_africa: Earth Globe Europe-Africa
  ^^^^^^01f30e% 🌎   \:earth_americas:   Earth Globe Americas
  ^^^^^^01f30f% 🌏   \:earth_asia:   Earth Globe Asia-Australia
  ^^^^^^01f310% 🌐   \:globe_with_meridians: Globe With Meridians
  ^^^^^^01f311% 🌑   \:new_moon: New Moon Symbol
  ^^^^^^01f312% 🌒   \:waxing_crescent_moon: Waxing Crescent Moon Symbol
  ^^^^^^01f313% 🌓   \:first_quarter_moon:   First Quarter Moon Symbol
  ^^^^^^01f314% 🌔   \:moon: Waxing Gibbous Moon Symbol
  ^^^^^^01f315% 🌕   \:full_moon:    Full Moon Symbol
  ^^^^^^01f316% 🌖   \:waning_gibbous_moon:  Waning Gibbous Moon Symbol
  ^^^^^^01f317% 🌗   \:last_quarter_moon:    Last Quarter Moon Symbol
  ^^^^^^01f318% 🌘   \:waning_crescent_moon: Waning Crescent Moon Symbol
  ^^^^^^01f319% 🌙   \:crescent_moon:    Crescent Moon
  ^^^^^^01f31a% 🌚   \:new_moon_with_face:   New Moon With Face
  ^^^^^^01f31b% 🌛   \:first_quarter_moon_with_face: First Quarter Moon With Face
  ^^^^^^01f31c% 🌜   \:last_quarter_moon_with_face:  Last Quarter Moon With Face
  ^^^^^^01f31d% 🌝   \:full_moon_with_face:  Full Moon With Face
  ^^^^^^01f31e% 🌞   \:sun_with_face:    Sun With Face
  ^^^^^^01f31f% 🌟   \:star2:    Glowing Star
  ^^^^^^01f320% 🌠   \:stars:    Shooting Star
  ^^^^^^01f330% 🌰   \:chestnut: Chestnut
  ^^^^^^01f331% 🌱   \:seedling: Seedling
  ^^^^^^01f332% 🌲   \:evergreen_tree:   Evergreen Tree
  ^^^^^^01f333% 🌳   \:deciduous_tree:   Deciduous Tree
  ^^^^^^01f334% 🌴   \:palm_tree:    Palm Tree
  ^^^^^^01f335% 🌵   \:cactus:   Cactus
  ^^^^^^01f337% 🌷   \:tulip:    Tulip
  ^^^^^^01f338% 🌸   \:cherry_blossom:   Cherry Blossom
  ^^^^^^01f339% 🌹   \:rose: Rose
  ^^^^^^01f33a% 🌺   \:hibiscus: Hibiscus
  ^^^^^^01f33b% 🌻   \:sunflower:    Sunflower
  ^^^^^^01f33c% 🌼   \:blossom:  Blossom
  ^^^^^^01f33d% 🌽   \:corn: Ear Of Maize
  ^^^^^^01f33e% 🌾   \:ear_of_rice:  Ear Of Rice
  ^^^^^^01f33f% 🌿   \:herb: Herb
  ^^^^^^01f340% 🍀   \:four_leaf_clover: Four Leaf Clover
  ^^^^^^01f341% 🍁   \:maple_leaf:   Maple Leaf
  ^^^^^^01f342% 🍂   \:fallen_leaf:  Fallen Leaf
  ^^^^^^01f343% 🍃   \:leaves:   Leaf Fluttering In Wind
  ^^^^^^01f344% 🍄   \:mushroom: Mushroom
  ^^^^^^01f345% 🍅   \:tomato:   Tomato
  ^^^^^^01f346% 🍆   \:eggplant: Aubergine
  ^^^^^^01f347% 🍇   \:grapes:   Grapes
  ^^^^^^01f348% 🍈   \:melon:    Melon
  ^^^^^^01f349% 🍉   \:watermelon:   Watermelon
  ^^^^^^01f34a% 🍊   \:tangerine:    Tangerine
  ^^^^^^01f34b% 🍋   \:lemon:    Lemon
  ^^^^^^01f34c% 🍌   \:banana:   Banana
  ^^^^^^01f34d% 🍍   \:pineapple:    Pineapple
  ^^^^^^01f34e% 🍎   \:apple:    Red Apple
  ^^^^^^01f34f% 🍏   \:green_apple:  Green Apple
  ^^^^^^01f350% 🍐   \:pear: Pear
  ^^^^^^01f351% 🍑   \:peach:    Peach
  ^^^^^^01f352% 🍒   \:cherries: Cherries
  ^^^^^^01f353% 🍓   \:strawberry:   Strawberry
  ^^^^^^01f354% 🍔   \:hamburger:    Hamburger
  ^^^^^^01f355% 🍕   \:pizza:    Slice Of Pizza
  ^^^^^^01f356% 🍖   \:meat_on_bone: Meat On Bone
  ^^^^^^01f357% 🍗   \:poultry_leg:  Poultry Leg
  ^^^^^^01f358% 🍘   \:rice_cracker: Rice Cracker
  ^^^^^^01f359% 🍙   \:rice_ball:    Rice Ball
  ^^^^^^01f35a% 🍚   \:rice: Cooked Rice
  ^^^^^^01f35b% 🍛   \:curry:    Curry And Rice
  ^^^^^^01f35c% 🍜   \:ramen:    Steaming Bowl
  ^^^^^^01f35d% 🍝   \:spaghetti:    Spaghetti
  ^^^^^^01f35e% 🍞   \:bread:    Bread
  ^^^^^^01f35f% 🍟   \:fries:    French Fries
  ^^^^^^01f360% 🍠   \:sweet_potato: Roasted Sweet Potato
  ^^^^^^01f361% 🍡   \:dango:    Dango
  ^^^^^^01f362% 🍢   \:oden: Oden
  ^^^^^^01f363% 🍣   \:sushi:    Sushi
  ^^^^^^01f364% 🍤   \:fried_shrimp: Fried Shrimp
  ^^^^^^01f365% 🍥   \:fish_cake:    Fish Cake With Swirl Design
  ^^^^^^01f366% 🍦   \:icecream: Soft Ice Cream
  ^^^^^^01f367% 🍧   \:shaved_ice:   Shaved Ice
  ^^^^^^01f368% 🍨   \:ice_cream:    Ice Cream
  ^^^^^^01f369% 🍩   \:doughnut: Doughnut
  ^^^^^^01f36a% 🍪   \:cookie:   Cookie
  ^^^^^^01f36b% 🍫   \:chocolate_bar:    Chocolate Bar
  ^^^^^^01f36c% 🍬   \:candy:    Candy
  ^^^^^^01f36d% 🍭   \:lollipop: Lollipop
  ^^^^^^01f36e% 🍮   \:custard:  Custard
  ^^^^^^01f36f% 🍯   \:honey_pot:    Honey Pot
  ^^^^^^01f370% 🍰   \:cake: Shortcake
  ^^^^^^01f371% 🍱   \:bento:    Bento Box
  ^^^^^^01f372% 🍲   \:stew: Pot Of Food
  ^^^^^^01f373% 🍳   \:egg:  Cooking
  ^^^^^^01f374% 🍴   \:fork_and_knife:   Fork And Knife
  ^^^^^^01f375% 🍵   \:tea:  Teacup Without Handle
  ^^^^^^01f376% 🍶   \:sake: Sake Bottle And Cup
  ^^^^^^01f377% 🍷   \:wine_glass:   Wine Glass
  ^^^^^^01f378% 🍸   \:cocktail: Cocktail Glass
  ^^^^^^01f379% 🍹   \:tropical_drink:   Tropical Drink
  ^^^^^^01f37a% 🍺   \:beer: Beer Mug
  ^^^^^^01f37b% 🍻   \:beers:    Clinking Beer Mugs
  ^^^^^^01f37c% 🍼   \:baby_bottle:  Baby Bottle
  ^^^^^^01f380% 🎀   \:ribbon:   Ribbon
  ^^^^^^01f381% 🎁   \:gift: Wrapped Present
  ^^^^^^01f382% 🎂   \:birthday: Birthday Cake
  ^^^^^^01f383% 🎃   \:jack_o_lantern:   Jack-O-Lantern
  ^^^^^^01f384% 🎄   \:christmas_tree:   Christmas Tree
  ^^^^^^01f385% 🎅   \:santa:    Father Christmas
  ^^^^^^01f386% 🎆   \:fireworks:    Fireworks
  ^^^^^^01f387% 🎇   \:sparkler: Firework Sparkler
  ^^^^^^01f388% 🎈   \:balloon:  Balloon
  ^^^^^^01f389% 🎉   \:tada: Party Popper
  ^^^^^^01f38a% 🎊   \:confetti_ball:    Confetti Ball
  ^^^^^^01f38b% 🎋   \:tanabata_tree:    Tanabata Tree
  ^^^^^^01f38c% 🎌   \:crossed_flags:    Crossed Flags
  ^^^^^^01f38d% 🎍   \:bamboo:   Pine Decoration
  ^^^^^^01f38e% 🎎   \:dolls:    Japanese Dolls
  ^^^^^^01f38f% 🎏   \:flags:    Carp Streamer
  ^^^^^^01f390% 🎐   \:wind_chime:   Wind Chime
  ^^^^^^01f391% 🎑   \:rice_scene:   Moon Viewing Ceremony
  ^^^^^^01f392% 🎒   \:school_satchel:   School Satchel
  ^^^^^^01f393% 🎓   \:mortar_board: Graduation Cap
  ^^^^^^01f3a0% 🎠   \:carousel_horse:   Carousel Horse
  ^^^^^^01f3a1% 🎡   \:ferris_wheel: Ferris Wheel
  ^^^^^^01f3a2% 🎢   \:roller_coaster:   Roller Coaster
  ^^^^^^01f3a3% 🎣   \:fishing_pole_and_fish:    Fishing Pole And Fish
  ^^^^^^01f3a4% 🎤   \:microphone:   Microphone
  ^^^^^^01f3a5% 🎥   \:movie_camera: Movie Camera
  ^^^^^^01f3a6% 🎦   \:cinema:   Cinema
  ^^^^^^01f3a7% 🎧   \:headphones:   Headphone
  ^^^^^^01f3a8% 🎨   \:art:  Artist Palette
  ^^^^^^01f3a9% 🎩   \:tophat:   Top Hat
  ^^^^^^01f3aa% 🎪   \:circus_tent:  Circus Tent
  ^^^^^^01f3ab% 🎫   \:ticket:   Ticket
  ^^^^^^01f3ac% 🎬   \:clapper:  Clapper Board
  ^^^^^^01f3ad% 🎭   \:performing_arts:  Performing Arts
  ^^^^^^01f3ae% 🎮   \:video_game:   Video Game
  ^^^^^^01f3af% 🎯   \:dart: Direct Hit
  ^^^^^^01f3b0% 🎰   \:slot_machine: Slot Machine
  ^^^^^^01f3b1% 🎱   \:8ball:    Billiards
  ^^^^^^01f3b2% 🎲   \:game_die: Game Die
  ^^^^^^01f3b3% 🎳   \:bowling:  Bowling
  ^^^^^^01f3b4% 🎴   \:flower_playing_cards: Flower Playing Cards
  ^^^^^^01f3b5% 🎵   \:musical_note: Musical Note
  ^^^^^^01f3b6% 🎶   \:notes:    Multiple Musical Notes
  ^^^^^^01f3b7% 🎷   \:saxophone:    Saxophone
  ^^^^^^01f3b8% 🎸   \:guitar:   Guitar
  ^^^^^^01f3b9% 🎹   \:musical_keyboard: Musical Keyboard
  ^^^^^^01f3ba% 🎺   \:trumpet:  Trumpet
  ^^^^^^01f3bb% 🎻   \:violin:   Violin
  ^^^^^^01f3bc% 🎼   \:musical_score:    Musical Score
  ^^^^^^01f3bd% 🎽   \:running_shirt_with_sash:  Running Shirt With Sash
  ^^^^^^01f3be% 🎾   \:tennis:   Tennis Racquet And Ball
  ^^^^^^01f3bf% 🎿   \:ski:  Ski And Ski Boot
  ^^^^^^01f3c0% 🏀   \:basketball:   Basketball And Hoop
  ^^^^^^01f3c1% 🏁   \:checkered_flag:   Chequered Flag
  ^^^^^^01f3c2% 🏂   \:snowboarder:  Snowboarder
  ^^^^^^01f3c3% 🏃   \:runner:   Runner
  ^^^^^^01f3c4% 🏄   \:surfer:   Surfer
  ^^^^^^01f3c6% 🏆   \:trophy:   Trophy
  ^^^^^^01f3c7% 🏇   \:horse_racing: Horse Racing
  ^^^^^^01f3c8% 🏈   \:football: American Football
  ^^^^^^01f3c9% 🏉   \:rugby_football:   Rugby Football
  ^^^^^^01f3ca% 🏊   \:swimmer:  Swimmer
  ^^^^^^01f3e0% 🏠   \:house:    House Building
  ^^^^^^01f3e1% 🏡   \:house_with_garden:    House With Garden
  ^^^^^^01f3e2% 🏢   \:office:   Office Building
  ^^^^^^01f3e3% 🏣   \:post_office:  Japanese Post Office
  ^^^^^^01f3e4% 🏤   \:european_post_office: European Post Office
  ^^^^^^01f3e5% 🏥   \:hospital: Hospital
  ^^^^^^01f3e6% 🏦   \:bank: Bank
  ^^^^^^01f3e7% 🏧   \:atm:  Automated Teller Machine
  ^^^^^^01f3e8% 🏨   \:hotel:    Hotel
  ^^^^^^01f3e9% 🏩   \:love_hotel:   Love Hotel
  ^^^^^^01f3ea% 🏪   \:convenience_store:    Convenience Store
  ^^^^^^01f3eb% 🏫   \:school:   School
  ^^^^^^01f3ec% 🏬   \:department_store: Department Store
  ^^^^^^01f3ed% 🏭   \:factory:  Factory
  ^^^^^^01f3ee% 🏮   \:izakaya_lantern:  Izakaya Lantern
  ^^^^^^01f3ef% 🏯   \:japanese_castle:  Japanese Castle
  ^^^^^^01f3f0% 🏰   \:european_castle:  European Castle
  ^^^^^^01f3fb% 🏻   \:skin-tone-2:  Emoji Modifier Fitzpatrick Type-1-2
  ^^^^^^01f3fc% 🏼   \:skin-tone-3:  Emoji Modifier Fitzpatrick Type-3
  ^^^^^^01f3fd% 🏽   \:skin-tone-4:  Emoji Modifier Fitzpatrick Type-4
  ^^^^^^01f3fe% 🏾   \:skin-tone-5:  Emoji Modifier Fitzpatrick Type-5
  ^^^^^^01f3ff% 🏿   \:skin-tone-6:  Emoji Modifier Fitzpatrick Type-6
  ^^^^^^01f400% 🐀   \:rat:  Rat
  ^^^^^^01f401% 🐁   \:mouse2:   Mouse
  ^^^^^^01f402% 🐂   \:ox:   Ox
  ^^^^^^01f403% 🐃   \:water_buffalo:    Water Buffalo
  ^^^^^^01f404% 🐄   \:cow2: Cow
  ^^^^^^01f405% 🐅   \:tiger2:   Tiger
  ^^^^^^01f406% 🐆   \:leopard:  Leopard
  ^^^^^^01f407% 🐇   \:rabbit2:  Rabbit
  ^^^^^^01f408% 🐈   \:cat2: Cat
  ^^^^^^01f409% 🐉   \:dragon:   Dragon
  ^^^^^^01f40a% 🐊   \:crocodile:    Crocodile
  ^^^^^^01f40b% 🐋   \:whale2:   Whale
  ^^^^^^01f40c% 🐌   \:snail:    Snail
  ^^^^^^01f40d% 🐍   \:snake:    Snake
  ^^^^^^01f40e% 🐎   \:racehorse:    Horse
  ^^^^^^01f40f% 🐏   \:ram:  Ram
  ^^^^^^01f410% 🐐   \:goat: Goat
  ^^^^^^01f411% 🐑   \:sheep:    Sheep
  ^^^^^^01f412% 🐒   \:monkey:   Monkey
  ^^^^^^01f413% 🐓   \:rooster:  Rooster
  ^^^^^^01f414% 🐔   \:chicken:  Chicken
  ^^^^^^01f415% 🐕   \:dog2: Dog
  ^^^^^^01f416% 🐖   \:pig2: Pig
  ^^^^^^01f417% 🐗   \:boar: Boar
  ^^^^^^01f418% 🐘   \:elephant: Elephant
  ^^^^^^01f419% 🐙   \:octopus:  Octopus
  ^^^^^^01f41a% 🐚   \:shell:    Spiral Shell
  ^^^^^^01f41b% 🐛   \:bug:  Bug
  ^^^^^^01f41c% 🐜   \:ant:  Ant
  ^^^^^^01f41d% 🐝   \:bee:  Honeybee
  ^^^^^^01f41e% 🐞   \:beetle:   Lady Beetle
  ^^^^^^01f41f% 🐟   \:fish: Fish
  ^^^^^^01f420% 🐠   \:tropical_fish:    Tropical Fish
  ^^^^^^01f421% 🐡   \:blowfish: Blowfish
  ^^^^^^01f422% 🐢   \:turtle:   Turtle
  ^^^^^^01f423% 🐣   \:hatching_chick:   Hatching Chick
  ^^^^^^01f424% 🐤   \:baby_chick:   Baby Chick
  ^^^^^^01f425% 🐥   \:hatched_chick:    Front-Facing Baby Chick
  ^^^^^^01f426% 🐦   \:bird: Bird
  ^^^^^^01f427% 🐧   \:penguin:  Penguin
  ^^^^^^01f428% 🐨   \:koala:    Koala
  ^^^^^^01f429% 🐩   \:poodle:   Poodle
  ^^^^^^01f42a% 🐪   \:dromedary_camel:  Dromedary Camel
  ^^^^^^01f42b% 🐫   \:camel:    Bactrian Camel
  ^^^^^^01f42c% 🐬   \:dolphin:  Dolphin
  ^^^^^^01f42d% 🐭   \:mouse:    Mouse Face
  ^^^^^^01f42e% 🐮   \:cow:  Cow Face
  ^^^^^^01f42f% 🐯   \:tiger:    Tiger Face
  ^^^^^^01f430% 🐰   \:rabbit:   Rabbit Face
  ^^^^^^01f431% 🐱   \:cat:  Cat Face
  ^^^^^^01f432% 🐲   \:dragon_face:  Dragon Face
  ^^^^^^01f433% 🐳   \:whale:    Spouting Whale
  ^^^^^^01f434% 🐴   \:horse:    Horse Face
  ^^^^^^01f435% 🐵   \:monkey_face:  Monkey Face
  ^^^^^^01f436% 🐶   \:dog:  Dog Face
  ^^^^^^01f437% 🐷   \:pig:  Pig Face
  ^^^^^^01f438% 🐸   \:frog: Frog Face
  ^^^^^^01f439% 🐹   \:hamster:  Hamster Face
  ^^^^^^01f43a% 🐺   \:wolf: Wolf Face
  ^^^^^^01f43b% 🐻   \:bear: Bear Face
  ^^^^^^01f43c% 🐼   \:panda_face:   Panda Face
  ^^^^^^01f43d% 🐽   \:pig_nose: Pig Nose
  ^^^^^^01f43e% 🐾   \:feet: Paw Prints
  ^^^^^^01f440% 👀   \:eyes: Eyes
  ^^^^^^01f442% 👂   \:ear:  Ear
  ^^^^^^01f443% 👃   \:nose: Nose
  ^^^^^^01f444% 👄   \:lips: Mouth
  ^^^^^^01f445% 👅   \:tongue:   Tongue
  ^^^^^^01f446% 👆   \:point_up_2:   White Up Pointing Backhand Index
  ^^^^^^01f447% 👇   \:point_down:   White Down Pointing Backhand Index
  ^^^^^^01f448% 👈   \:point_left:   White Left Pointing Backhand Index
  ^^^^^^01f449% 👉   \:point_right:  White Right Pointing Backhand Index
  ^^^^^^01f44a% 👊   \:facepunch:    Fisted Hand Sign
  ^^^^^^01f44b% 👋   \:wave: Waving Hand Sign
  ^^^^^^01f44c% 👌   \:ok_hand:  Ok Hand Sign
  ^^^^^^01f44d% 👍   \:+1:   Thumbs Up Sign
  ^^^^^^01f44e% 👎   \:-1:   Thumbs Down Sign
  ^^^^^^01f44f% 👏   \:clap: Clapping Hands Sign
  ^^^^^^01f450% 👐   \:open_hands:   Open Hands Sign
  ^^^^^^01f451% 👑   \:crown:    Crown
  ^^^^^^01f452% 👒   \:womans_hat:   Womans Hat
  ^^^^^^01f453% 👓   \:eyeglasses:   Eyeglasses
  ^^^^^^01f454% 👔   \:necktie:  Necktie
  ^^^^^^01f455% 👕   \:shirt:    T-Shirt
  ^^^^^^01f456% 👖   \:jeans:    Jeans
  ^^^^^^01f457% 👗   \:dress:    Dress
  ^^^^^^01f458% 👘   \:kimono:   Kimono
  ^^^^^^01f459% 👙   \:bikini:   Bikini
  ^^^^^^01f45a% 👚   \:womans_clothes:   Womans Clothes
  ^^^^^^01f45b% 👛   \:purse:    Purse
  ^^^^^^01f45c% 👜   \:handbag:  Handbag
  ^^^^^^01f45d% 👝   \:pouch:    Pouch
  ^^^^^^01f45e% 👞   \:mans_shoe:    Mans Shoe
  ^^^^^^01f45f% 👟   \:athletic_shoe:    Athletic Shoe
  ^^^^^^01f460% 👠   \:high_heel:    High-Heeled Shoe
  ^^^^^^01f461% 👡   \:sandal:   Womans Sandal
  ^^^^^^01f462% 👢   \:boot: Womans Boots
  ^^^^^^01f463% 👣   \:footprints:   Footprints
  ^^^^^^01f464% 👤   \:bust_in_silhouette:   Bust In Silhouette
  ^^^^^^01f465% 👥   \:busts_in_silhouette:  Busts In Silhouette
  ^^^^^^01f466% 👦   \:boy:  Boy
  ^^^^^^01f467% 👧   \:girl: Girl
  ^^^^^^01f468% 👨   \:man:  Man
  ^^^^^^01f469% 👩   \:woman:    Woman
  ^^^^^^01f46a% 👪   \:family:   Family
  ^^^^^^01f46b% 👫   \:couple:   Man And Woman Holding Hands
  ^^^^^^01f46c% 👬   \:two_men_holding_hands:    Two Men Holding Hands
  ^^^^^^01f46d% 👭   \:two_women_holding_hands:  Two Women Holding Hands
  ^^^^^^01f46e% 👮   \:cop:  Police Officer
  ^^^^^^01f46f% 👯   \:dancers:  Woman With Bunny Ears
  ^^^^^^01f470% 👰   \:bride_with_veil:  Bride With Veil
  ^^^^^^01f471% 👱   \:person_with_blond_hair:   Person With Blond Hair
  ^^^^^^01f472% 👲   \:man_with_gua_pi_mao:  Man With Gua Pi Mao
  ^^^^^^01f473% 👳   \:man_with_turban:  Man With Turban
  ^^^^^^01f474% 👴   \:older_man:    Older Man
  ^^^^^^01f475% 👵   \:older_woman:  Older Woman
  ^^^^^^01f476% 👶   \:baby: Baby
  ^^^^^^01f477% 👷   \:construction_worker:  Construction Worker
  ^^^^^^01f478% 👸   \:princess: Princess
  ^^^^^^01f479% 👹   \:japanese_ogre:    Japanese Ogre
  ^^^^^^01f47a% 👺   \:japanese_goblin:  Japanese Goblin
  ^^^^^^01f47b% 👻   \:ghost:    Ghost
  ^^^^^^01f47c% 👼   \:angel:    Baby Angel
  ^^^^^^01f47d% 👽   \:alien:    Extraterrestrial Alien
  ^^^^^^01f47e% 👾   \:space_invader:    Alien Monster
  ^^^^^^01f47f% 👿   \:imp:  Imp
  ^^^^^^01f480% 💀   \:skull:    Skull
  ^^^^^^01f481% 💁   \:information_desk_person:  Information Desk Person
  ^^^^^^01f482% 💂   \:guardsman:    Guardsman
  ^^^^^^01f483% 💃   \:dancer:   Dancer
  ^^^^^^01f484% 💄   \:lipstick: Lipstick
  ^^^^^^01f485% 💅   \:nail_care:    Nail Polish
  ^^^^^^01f486% 💆   \:massage:  Face Massage
  ^^^^^^01f487% 💇   \:haircut:  Haircut
  ^^^^^^01f488% 💈   \:barber:   Barber Pole
  ^^^^^^01f489% 💉   \:syringe:  Syringe
  ^^^^^^01f48a% 💊   \:pill: Pill
  ^^^^^^01f48b% 💋   \:kiss: Kiss Mark
  ^^^^^^01f48c% 💌   \:love_letter:  Love Letter
  ^^^^^^01f48d% 💍   \:ring: Ring
  ^^^^^^01f48e% 💎   \:gem:  Gem Stone
  ^^^^^^01f48f% 💏   \:couplekiss:   Kiss
  ^^^^^^01f490% 💐   \:bouquet:  Bouquet
  ^^^^^^01f491% 💑   \:couple_with_heart:    Couple With Heart
  ^^^^^^01f492% 💒   \:wedding:  Wedding
  ^^^^^^01f493% 💓   \:heartbeat:    Beating Heart
  ^^^^^^01f494% 💔   \:broken_heart: Broken Heart
  ^^^^^^01f495% 💕   \:two_hearts:   Two Hearts
  ^^^^^^01f496% 💖   \:sparkling_heart:  Sparkling Heart
  ^^^^^^01f497% 💗   \:heartpulse:   Growing Heart
  ^^^^^^01f498% 💘   \:cupid:    Heart With Arrow
  ^^^^^^01f499% 💙   \:blue_heart:   Blue Heart
  ^^^^^^01f49a% 💚   \:green_heart:  Green Heart
  ^^^^^^01f49b% 💛   \:yellow_heart: Yellow Heart
  ^^^^^^01f49c% 💜   \:purple_heart: Purple Heart
  ^^^^^^01f49d% 💝   \:gift_heart:   Heart With Ribbon
  ^^^^^^01f49e% 💞   \:revolving_hearts: Revolving Hearts
  ^^^^^^01f49f% 💟   \:heart_decoration: Heart Decoration
  ^^^^^^01f4a0% 💠   \:diamond_shape_with_a_dot_inside:  Diamond Shape With A Dot Inside
  ^^^^^^01f4a1% 💡   \:bulb: Electric Light Bulb
  ^^^^^^01f4a2% 💢   \:anger:    Anger Symbol
  ^^^^^^01f4a3% 💣   \:bomb: Bomb
  ^^^^^^01f4a4% 💤   \:zzz:  Sleeping Symbol
  ^^^^^^01f4a5% 💥   \:boom: Collision Symbol
  ^^^^^^01f4a6% 💦   \:sweat_drops:  Splashing Sweat Symbol
  ^^^^^^01f4a7% 💧   \:droplet:  Droplet
  ^^^^^^01f4a8% 💨   \:dash: Dash Symbol
  ^^^^^^01f4a9% 💩   \:hankey:   Pile Of Poo
  ^^^^^^01f4aa% 💪   \:muscle:   Flexed Biceps
  ^^^^^^01f4ab% 💫   \:dizzy:    Dizzy Symbol
  ^^^^^^01f4ac% 💬   \:speech_balloon:   Speech Balloon
  ^^^^^^01f4ad% 💭   \:thought_balloon:  Thought Balloon
  ^^^^^^01f4ae% 💮   \:white_flower: White Flower
  ^^^^^^01f4af% 💯   \:100:  Hundred Points Symbol
  ^^^^^^01f4b0% 💰   \:moneybag: Money Bag
  ^^^^^^01f4b1% 💱   \:currency_exchange:    Currency Exchange
  ^^^^^^01f4b2% 💲   \:heavy_dollar_sign:    Heavy Dollar Sign
  ^^^^^^01f4b3% 💳   \:credit_card:  Credit Card
  ^^^^^^01f4b4% 💴   \:yen:  Banknote With Yen Sign
  ^^^^^^01f4b5% 💵   \:dollar:   Banknote With Dollar Sign
  ^^^^^^01f4b6% 💶   \:euro: Banknote With Euro Sign
  ^^^^^^01f4b7% 💷   \:pound:    Banknote With Pound Sign
  ^^^^^^01f4b8% 💸   \:money_with_wings: Money With Wings
  ^^^^^^01f4b9% 💹   \:chart:    Chart With Upwards Trend And Yen Sign
  ^^^^^^01f4ba% 💺   \:seat: Seat
  ^^^^^^01f4bb% 💻   \:computer: Personal Computer
  ^^^^^^01f4bc% 💼   \:briefcase:    Briefcase
  ^^^^^^01f4bd% 💽   \:minidisc: Minidisc
  ^^^^^^01f4be% 💾   \:floppy_disk:  Floppy Disk
  ^^^^^^01f4bf% 💿   \:cd:   Optical Disc
  ^^^^^^01f4c0% 📀   \:dvd:  Dvd
  ^^^^^^01f4c1% 📁   \:file_folder:  File Folder
  ^^^^^^01f4c2% 📂   \:open_file_folder: Open File Folder
  ^^^^^^01f4c3% 📃   \:page_with_curl:   Page With Curl
  ^^^^^^01f4c4% 📄   \:page_facing_up:   Page Facing Up
  ^^^^^^01f4c5% 📅   \:date: Calendar
  ^^^^^^01f4c6% 📆   \:calendar: Tear-Off Calendar
  ^^^^^^01f4c7% 📇   \:card_index:   Card Index
  ^^^^^^01f4c8% 📈   \:chart_with_upwards_trend: Chart With Upwards Trend
  ^^^^^^01f4c9% 📉   \:chart_with_downwards_trend:   Chart With Downwards Trend
  ^^^^^^01f4ca% 📊   \:bar_chart:    Bar Chart
  ^^^^^^01f4cb% 📋   \:clipboard:    Clipboard
  ^^^^^^01f4cc% 📌   \:pushpin:  Pushpin
  ^^^^^^01f4cd% 📍   \:round_pushpin:    Round Pushpin
  ^^^^^^01f4ce% 📎   \:paperclip:    Paperclip
  ^^^^^^01f4cf% 📏   \:straight_ruler:   Straight Ruler
  ^^^^^^01f4d0% 📐   \:triangular_ruler: Triangular Ruler
  ^^^^^^01f4d1% 📑   \:bookmark_tabs:    Bookmark Tabs
  ^^^^^^01f4d2% 📒   \:ledger:   Ledger
  ^^^^^^01f4d3% 📓   \:notebook: Notebook
  ^^^^^^01f4d4% 📔   \:notebook_with_decorative_cover:   Notebook With Decorative Cover
  ^^^^^^01f4d5% 📕   \:closed_book:  Closed Book
  ^^^^^^01f4d6% 📖   \:book: Open Book
  ^^^^^^01f4d7% 📗   \:green_book:   Green Book
  ^^^^^^01f4d8% 📘   \:blue_book:    Blue Book
  ^^^^^^01f4d9% 📙   \:orange_book:  Orange Book
  ^^^^^^01f4da% 📚   \:books:    Books
  ^^^^^^01f4db% 📛   \:name_badge:   Name Badge
  ^^^^^^01f4dc% 📜   \:scroll:   Scroll
  ^^^^^^01f4dd% 📝   \:memo: Memo
  ^^^^^^01f4de% 📞   \:telephone_receiver:   Telephone Receiver
  ^^^^^^01f4df% 📟   \:pager:    Pager
  ^^^^^^01f4e0% 📠   \:fax:  Fax Machine
  ^^^^^^01f4e1% 📡   \:satellite:    Satellite Antenna
  ^^^^^^01f4e2% 📢   \:loudspeaker:  Public Address Loudspeaker
  ^^^^^^01f4e3% 📣   \:mega: Cheering Megaphone
  ^^^^^^01f4e4% 📤   \:outbox_tray:  Outbox Tray
  ^^^^^^01f4e5% 📥   \:inbox_tray:   Inbox Tray
  ^^^^^^01f4e6% 📦   \:package:  Package
  ^^^^^^01f4e7% 📧   \:e-mail:   E-Mail Symbol
  ^^^^^^01f4e8% 📨   \:incoming_envelope:    Incoming Envelope
  ^^^^^^01f4e9% 📩   \:envelope_with_arrow:  Envelope With Downwards Arrow Above
  ^^^^^^01f4ea% 📪   \:mailbox_closed:   Closed Mailbox With Lowered Flag
  ^^^^^^01f4eb% 📫   \:mailbox:  Closed Mailbox With Raised Flag
  ^^^^^^01f4ec% 📬   \:mailbox_with_mail:    Open Mailbox With Raised Flag
  ^^^^^^01f4ed% 📭   \:mailbox_with_no_mail: Open Mailbox With Lowered Flag
  ^^^^^^01f4ee% 📮   \:postbox:  Postbox
  ^^^^^^01f4ef% 📯   \:postal_horn:  Postal Horn
  ^^^^^^01f4f0% 📰   \:newspaper:    Newspaper
  ^^^^^^01f4f1% 📱   \:iphone:   Mobile Phone
  ^^^^^^01f4f2% 📲   \:calling:  Mobile Phone With Rightwards Arrow At Left
  ^^^^^^01f4f3% 📳   \:vibration_mode:   Vibration Mode
  ^^^^^^01f4f4% 📴   \:mobile_phone_off: Mobile Phone Off
  ^^^^^^01f4f5% 📵   \:no_mobile_phones: No Mobile Phones
  ^^^^^^01f4f6% 📶   \:signal_strength:  Antenna With Bars
  ^^^^^^01f4f7% 📷   \:camera:   Camera
  ^^^^^^01f4f9% 📹   \:video_camera: Video Camera
  ^^^^^^01f4fa% 📺   \:tv:   Television
  ^^^^^^01f4fb% 📻   \:radio:    Radio
  ^^^^^^01f4fc% 📼   \:vhs:  Videocassette
  ^^^^^^01f500% 🔀   \:twisted_rightwards_arrows:    Twisted Rightwards Arrows
  ^^^^^^01f501% 🔁   \:repeat:   Clockwise Rightwards And Leftwards Open Circle Arrows
  ^^^^^^01f502% 🔂   \:repeat_one:   Clockwise Rightwards And Leftwards Open Circle Arrows With Circled One Overlay
  ^^^^^^01f503% 🔃   \:arrows_clockwise: Clockwise Downwards And Upwards Open Circle Arrows
  ^^^^^^01f504% 🔄   \:arrows_counterclockwise:  Anticlockwise Downwards And Upwards Open Circle Arrows
  ^^^^^^01f505% 🔅   \:low_brightness:   Low Brightness Symbol
  ^^^^^^01f506% 🔆   \:high_brightness:  High Brightness Symbol
  ^^^^^^01f507% 🔇   \:mute: Speaker With Cancellation Stroke
  ^^^^^^01f508% 🔈   \:speaker:  Speaker
  ^^^^^^01f509% 🔉   \:sound:    Speaker With One Sound Wave
  ^^^^^^01f50a% 🔊   \:loud_sound:   Speaker With Three Sound Waves
  ^^^^^^01f50b% 🔋   \:battery:  Battery
  ^^^^^^01f50c% 🔌   \:electric_plug:    Electric Plug
  ^^^^^^01f50d% 🔍   \:mag:  Left-Pointing Magnifying Glass
  ^^^^^^01f50e% 🔎   \:mag_right:    Right-Pointing Magnifying Glass
  ^^^^^^01f50f% 🔏   \:lock_with_ink_pen:    Lock With Ink Pen
  ^^^^^^01f510% 🔐   \:closed_lock_with_key: Closed Lock With Key
  ^^^^^^01f511% 🔑   \:key:  Key
  ^^^^^^01f512% 🔒   \:lock: Lock
  ^^^^^^01f513% 🔓   \:unlock:   Open Lock
  ^^^^^^01f514% 🔔   \:bell: Bell
  ^^^^^^01f515% 🔕   \:no_bell:  Bell With Cancellation Stroke
  ^^^^^^01f516% 🔖   \:bookmark: Bookmark
  ^^^^^^01f517% 🔗   \:link: Link Symbol
  ^^^^^^01f518% 🔘   \:radio_button: Radio Button
  ^^^^^^01f519% 🔙   \:back: Back With Leftwards Arrow Above
  ^^^^^^01f51a% 🔚   \:end:  End With Leftwards Arrow Above
  ^^^^^^01f51b% 🔛   \:on:   On With Exclamation Mark With Left Right Arrow Above
  ^^^^^^01f51c% 🔜   \:soon: Soon With Rightwards Arrow Above
  ^^^^^^01f51d% 🔝   \:top:  Top With Upwards Arrow Above
  ^^^^^^01f51e% 🔞   \:underage: No One Under Eighteen Symbol
  ^^^^^^01f51f% 🔟   \:keycap_ten:   Keycap Ten
  ^^^^^^01f520% 🔠   \:capital_abcd: Input Symbol For Latin Capital Letters
  ^^^^^^01f521% 🔡   \:abcd: Input Symbol For Latin Small Letters
  ^^^^^^01f522% 🔢   \:1234: Input Symbol For Numbers
  ^^^^^^01f523% 🔣   \:symbols:  Input Symbol For Symbols
  ^^^^^^01f524% 🔤   \:abc:  Input Symbol For Latin Letters
  ^^^^^^01f525% 🔥   \:fire: Fire
  ^^^^^^01f526% 🔦   \:flashlight:   Electric Torch
  ^^^^^^01f527% 🔧   \:wrench:   Wrench
  ^^^^^^01f528% 🔨   \:hammer:   Hammer
  ^^^^^^01f529% 🔩   \:nut_and_bolt: Nut And Bolt
  ^^^^^^01f52a% 🔪   \:hocho:    Hocho
  ^^^^^^01f52b% 🔫   \:gun:  Pistol
  ^^^^^^01f52c% 🔬   \:microscope:   Microscope
  ^^^^^^01f52d% 🔭   \:telescope:    Telescope
  ^^^^^^01f52e% 🔮   \:crystal_ball: Crystal Ball
  ^^^^^^01f52f% 🔯   \:six_pointed_star: Six Pointed Star With Middle Dot
  ^^^^^^01f530% 🔰   \:beginner: Japanese Symbol For Beginner
  ^^^^^^01f531% 🔱   \:trident:  Trident Emblem
  ^^^^^^01f532% 🔲   \:black_square_button:  Black Square Button
  ^^^^^^01f533% 🔳   \:white_square_button:  White Square Button
  ^^^^^^01f534% 🔴   \:red_circle:   Large Red Circle
  ^^^^^^01f535% 🔵   \:large_blue_circle:    Large Blue Circle
  ^^^^^^01f536% 🔶   \:large_orange_diamond: Large Orange Diamond
  ^^^^^^01f537% 🔷   \:large_blue_diamond:   Large Blue Diamond
  ^^^^^^01f538% 🔸   \:small_orange_diamond: Small Orange Diamond
  ^^^^^^01f539% 🔹   \:small_blue_diamond:   Small Blue Diamond
  ^^^^^^01f53a% 🔺   \:small_red_triangle:   Up-Pointing Red Triangle
  ^^^^^^01f53b% 🔻   \:small_red_triangle_down:  Down-Pointing Red Triangle
  ^^^^^^01f53c% 🔼   \:arrow_up_small:   Up-Pointing Small Red Triangle
  ^^^^^^01f53d% 🔽   \:arrow_down_small: Down-Pointing Small Red Triangle
  ^^^^^^01f550% 🕐   \:clock1:   Clock Face One Oclock
  ^^^^^^01f551% 🕑   \:clock2:   Clock Face Two Oclock
  ^^^^^^01f552% 🕒   \:clock3:   Clock Face Three Oclock
  ^^^^^^01f553% 🕓   \:clock4:   Clock Face Four Oclock
  ^^^^^^01f554% 🕔   \:clock5:   Clock Face Five Oclock
  ^^^^^^01f555% 🕕   \:clock6:   Clock Face Six Oclock
  ^^^^^^01f556% 🕖   \:clock7:   Clock Face Seven Oclock
  ^^^^^^01f557% 🕗   \:clock8:   Clock Face Eight Oclock
  ^^^^^^01f558% 🕘   \:clock9:   Clock Face Nine Oclock
  ^^^^^^01f559% 🕙   \:clock10:  Clock Face Ten Oclock
  ^^^^^^01f55a% 🕚   \:clock11:  Clock Face Eleven Oclock
  ^^^^^^01f55b% 🕛   \:clock12:  Clock Face Twelve Oclock
  ^^^^^^01f55c% 🕜   \:clock130: Clock Face One-Thirty
  ^^^^^^01f55d% 🕝   \:clock230: Clock Face Two-Thirty
  ^^^^^^01f55e% 🕞   \:clock330: Clock Face Three-Thirty
  ^^^^^^01f55f% 🕟   \:clock430: Clock Face Four-Thirty
  ^^^^^^01f560% 🕠   \:clock530: Clock Face Five-Thirty
  ^^^^^^01f561% 🕡   \:clock630: Clock Face Six-Thirty
  ^^^^^^01f562% 🕢   \:clock730: Clock Face Seven-Thirty
  ^^^^^^01f563% 🕣   \:clock830: Clock Face Eight-Thirty
  ^^^^^^01f564% 🕤   \:clock930: Clock Face Nine-Thirty
  ^^^^^^01f565% 🕥   \:clock1030:    Clock Face Ten-Thirty
  ^^^^^^01f566% 🕦   \:clock1130:    Clock Face Eleven-Thirty
  ^^^^^^01f567% 🕧   \:clock1230:    Clock Face Twelve-Thirty
  ^^^^^^01f5fb% 🗻   \:mount_fuji:   Mount Fuji
  ^^^^^^01f5fc% 🗼   \:tokyo_tower:  Tokyo Tower
  ^^^^^^01f5fd% 🗽   \:statue_of_liberty:    Statue Of Liberty
  ^^^^^^01f5fe% 🗾   \:japan:    Silhouette Of Japan
  ^^^^^^01f5ff% 🗿   \:moyai:    Moyai
  ^^^^^^01f600% 😀   \:grinning: Grinning Face
  ^^^^^^01f601% 😁   \:grin: Grinning Face With Smiling Eyes
  ^^^^^^01f602% 😂   \:joy:  Face With Tears Of Joy
  ^^^^^^01f603% 😃   \:smiley:   Smiling Face With Open Mouth
  ^^^^^^01f604% 😄   \:smile:    Smiling Face With Open Mouth And Smiling Eyes
  ^^^^^^01f605% 😅   \:sweat_smile:  Smiling Face With Open Mouth And Cold Sweat
  ^^^^^^01f606% 😆   \:laughing: Smiling Face With Open Mouth And Tightly-Closed Eyes
  ^^^^^^01f607% 😇   \:innocent: Smiling Face With Halo
  ^^^^^^01f608% 😈   \:smiling_imp:  Smiling Face With Horns
  ^^^^^^01f609% 😉   \:wink: Winking Face
  ^^^^^^01f60a% 😊   \:blush:    Smiling Face With Smiling Eyes
  ^^^^^^01f60b% 😋   \:yum:  Face Savouring Delicious Food
  ^^^^^^01f60c% 😌   \:relieved: Relieved Face
  ^^^^^^01f60d% 😍   \:heart_eyes:   Smiling Face With Heart-Shaped Eyes
  ^^^^^^01f60e% 😎   \:sunglasses:   Smiling Face With Sunglasses
  ^^^^^^01f60f% 😏   \:smirk:    Smirking Face
  ^^^^^^01f610% 😐   \:neutral_face: Neutral Face
  ^^^^^^01f611% 😑   \:expressionless:   Expressionless Face
  ^^^^^^01f612% 😒   \:unamused: Unamused Face
  ^^^^^^01f613% 😓   \:sweat:    Face With Cold Sweat
  ^^^^^^01f614% 😔   \:pensive:  Pensive Face
  ^^^^^^01f615% 😕   \:confused: Confused Face
  ^^^^^^01f616% 😖   \:confounded:   Confounded Face
  ^^^^^^01f617% 😗   \:kissing:  Kissing Face
  ^^^^^^01f618% 😘   \:kissing_heart:    Face Throwing A Kiss
  ^^^^^^01f619% 😙   \:kissing_smiling_eyes: Kissing Face With Smiling Eyes
  ^^^^^^01f61a% 😚   \:kissing_closed_eyes:  Kissing Face With Closed Eyes
  ^^^^^^01f61b% 😛   \:stuck_out_tongue: Face With Stuck-Out Tongue
  ^^^^^^01f61c% 😜   \:stuck_out_tongue_winking_eye: Face With Stuck-Out Tongue And Winking Eye
  ^^^^^^01f61d% 😝   \:stuck_out_tongue_closed_eyes: Face With Stuck-Out Tongue And Tightly-Closed Eyes
  ^^^^^^01f61e% 😞   \:disappointed: Disappointed Face
  ^^^^^^01f61f% 😟   \:worried:  Worried Face
  ^^^^^^01f620% 😠   \:angry:    Angry Face
  ^^^^^^01f621% 😡   \:rage: Pouting Face
  ^^^^^^01f622% 😢   \:cry:  Crying Face
  ^^^^^^01f623% 😣   \:persevere:    Persevering Face
  ^^^^^^01f624% 😤   \:triumph:  Face With Look Of Triumph
  ^^^^^^01f625% 😥   \:disappointed_relieved:    Disappointed But Relieved Face
  ^^^^^^01f626% 😦   \:frowning: Frowning Face With Open Mouth
  ^^^^^^01f627% 😧   \:anguished:    Anguished Face
  ^^^^^^01f628% 😨   \:fearful:  Fearful Face
  ^^^^^^01f629% 😩   \:weary:    Weary Face
  ^^^^^^01f62a% 😪   \:sleepy:   Sleepy Face
  ^^^^^^01f62b% 😫   \:tired_face:   Tired Face
  ^^^^^^01f62c% 😬   \:grimacing:    Grimacing Face
  ^^^^^^01f62d% 😭   \:sob:  Loudly Crying Face
  ^^^^^^01f62e% 😮   \:open_mouth:   Face With Open Mouth
  ^^^^^^01f62f% 😯   \:hushed:   Hushed Face
  ^^^^^^01f630% 😰   \:cold_sweat:   Face With Open Mouth And Cold Sweat
  ^^^^^^01f631% 😱   \:scream:   Face Screaming In Fear
  ^^^^^^01f632% 😲   \:astonished:   Astonished Face
  ^^^^^^01f633% 😳   \:flushed:  Flushed Face
  ^^^^^^01f634% 😴   \:sleeping: Sleeping Face
  ^^^^^^01f635% 😵   \:dizzy_face:   Dizzy Face
  ^^^^^^01f636% 😶   \:no_mouth: Face Without Mouth
  ^^^^^^01f637% 😷   \:mask: Face With Medical Mask
  ^^^^^^01f638% 😸   \:smile_cat:    Grinning Cat Face With Smiling Eyes
  ^^^^^^01f639% 😹   \:joy_cat:  Cat Face With Tears Of Joy
  ^^^^^^01f63a% 😺   \:smiley_cat:   Smiling Cat Face With Open Mouth
  ^^^^^^01f63b% 😻   \:heart_eyes_cat:   Smiling Cat Face With Heart-Shaped Eyes
  ^^^^^^01f63c% 😼   \:smirk_cat:    Cat Face With Wry Smile
  ^^^^^^01f63d% 😽   \:kissing_cat:  Kissing Cat Face With Closed Eyes
  ^^^^^^01f63e% 😾   \:pouting_cat:  Pouting Cat Face
  ^^^^^^01f63f% 😿   \:crying_cat_face:  Crying Cat Face
  ^^^^^^01f640% 🙀   \:scream_cat:   Weary Cat Face
  ^^^^^^01f645% 🙅   \:no_good:  Face With No Good Gesture
  ^^^^^^01f646% 🙆   \:ok_woman: Face With Ok Gesture
  ^^^^^^01f647% 🙇   \:bow:  Person Bowing Deeply
  ^^^^^^01f648% 🙈   \:see_no_evil:  See-No-Evil Monkey
  ^^^^^^01f649% 🙉   \:hear_no_evil: Hear-No-Evil Monkey
  ^^^^^^01f64a% 🙊   \:speak_no_evil:    Speak-No-Evil Monkey
  ^^^^^^01f64b% 🙋   \:raising_hand: Happy Person Raising One Hand
  ^^^^^^01f64c% 🙌   \:raised_hands: Person Raising Both Hands In Celebration
  ^^^^^^01f64d% 🙍   \:person_frowning:  Person Frowning
  ^^^^^^01f64e% 🙎   \:person_with_pouting_face: Person With Pouting Face
  ^^^^^^01f64f% 🙏   \:pray: Person With Folded Hands
  ^^^^^^01f680% 🚀   \:rocket:   Rocket
  ^^^^^^01f681% 🚁   \:helicopter:   Helicopter
  ^^^^^^01f682% 🚂   \:steam_locomotive: Steam Locomotive
  ^^^^^^01f683% 🚃   \:railway_car:  Railway Car
  ^^^^^^01f684% 🚄   \:bullettrain_side: High-Speed Train
  ^^^^^^01f685% 🚅   \:bullettrain_front:    High-Speed Train With Bullet Nose
  ^^^^^^01f686% 🚆   \:train2:   Train
  ^^^^^^01f687% 🚇   \:metro:    Metro
  ^^^^^^01f688% 🚈   \:light_rail:   Light Rail
  ^^^^^^01f689% 🚉   \:station:  Station
  ^^^^^^01f68a% 🚊   \:tram: Tram
  ^^^^^^01f68b% 🚋   \:train:    Tram Car
  ^^^^^^01f68c% 🚌   \:bus:  Bus
  ^^^^^^01f68d% 🚍   \:oncoming_bus: Oncoming Bus
  ^^^^^^01f68e% 🚎   \:trolleybus:   Trolleybus
  ^^^^^^01f68f% 🚏   \:busstop:  Bus Stop
  ^^^^^^01f690% 🚐   \:minibus:  Minibus
  ^^^^^^01f691% 🚑   \:ambulance:    Ambulance
  ^^^^^^01f692% 🚒   \:fire_engine:  Fire Engine
  ^^^^^^01f693% 🚓   \:police_car:   Police Car
  ^^^^^^01f694% 🚔   \:oncoming_police_car:  Oncoming Police Car
  ^^^^^^01f695% 🚕   \:taxi: Taxi
  ^^^^^^01f696% 🚖   \:oncoming_taxi:    Oncoming Taxi
  ^^^^^^01f697% 🚗   \:car:  Automobile
  ^^^^^^01f698% 🚘   \:oncoming_automobile:  Oncoming Automobile
  ^^^^^^01f699% 🚙   \:blue_car: Recreational Vehicle
  ^^^^^^01f69a% 🚚   \:truck:    Delivery Truck
  ^^^^^^01f69b% 🚛   \:articulated_lorry:    Articulated Lorry
  ^^^^^^01f69c% 🚜   \:tractor:  Tractor
  ^^^^^^01f69d% 🚝   \:monorail: Monorail
  ^^^^^^01f69e% 🚞   \:mountain_railway: Mountain Railway
  ^^^^^^01f69f% 🚟   \:suspension_railway:   Suspension Railway
  ^^^^^^01f6a0% 🚠   \:mountain_cableway:    Mountain Cableway
  ^^^^^^01f6a1% 🚡   \:aerial_tramway:   Aerial Tramway
  ^^^^^^01f6a2% 🚢   \:ship: Ship
  ^^^^^^01f6a3% 🚣   \:rowboat:  Rowboat
  ^^^^^^01f6a4% 🚤   \:speedboat:    Speedboat
  ^^^^^^01f6a5% 🚥   \:traffic_light:    Horizontal Traffic Light
  ^^^^^^01f6a6% 🚦   \:vertical_traffic_light:   Vertical Traffic Light
  ^^^^^^01f6a7% 🚧   \:construction: Construction Sign
  ^^^^^^01f6a8% 🚨   \:rotating_light:   Police Cars Revolving Light
  ^^^^^^01f6a9% 🚩   \:triangular_flag_on_post:  Triangular Flag On Post
  ^^^^^^01f6aa% 🚪   \:door: Door
  ^^^^^^01f6ab% 🚫   \:no_entry_sign:    No Entry Sign
  ^^^^^^01f6ac% 🚬   \:smoking:  Smoking Symbol
  ^^^^^^01f6ad% 🚭   \:no_smoking:   No Smoking Symbol
  ^^^^^^01f6ae% 🚮   \:put_litter_in_its_place:  Put Litter In Its Place Symbol
  ^^^^^^01f6af% 🚯   \:do_not_litter:    Do Not Litter Symbol
  ^^^^^^01f6b0% 🚰   \:potable_water:    Potable Water Symbol
  ^^^^^^01f6b1% 🚱   \:non-potable_water:    Non-Potable Water Symbol
  ^^^^^^01f6b2% 🚲   \:bike: Bicycle
  ^^^^^^01f6b3% 🚳   \:no_bicycles:  No Bicycles
  ^^^^^^01f6b4% 🚴   \:bicyclist:    Bicyclist
  ^^^^^^01f6b5% 🚵   \:mountain_bicyclist:   Mountain Bicyclist
  ^^^^^^01f6b6% 🚶   \:walking:  Pedestrian
  ^^^^^^01f6b7% 🚷   \:no_pedestrians:   No Pedestrians
  ^^^^^^01f6b8% 🚸   \:children_crossing:    Children Crossing
  ^^^^^^01f6b9% 🚹   \:mens: Mens Symbol
  ^^^^^^01f6ba% 🚺   \:womens:   Womens Symbol
  ^^^^^^01f6bb% 🚻   \:restroom: Restroom
  ^^^^^^01f6bc% 🚼   \:baby_symbol:  Baby Symbol
  ^^^^^^01f6bd% 🚽   \:toilet:   Toilet
  ^^^^^^01f6be% 🚾   \:wc:   Water Closet
  ^^^^^^01f6bf% 🚿   \:shower:   Shower
  ^^^^^^01f6c0% 🛀   \:bath: Bath
  ^^^^^^01f6c1% 🛁   \:bathtub:  Bathtub
  ^^^^^^01f6c2% 🛂   \:passport_control: Passport Control
  ^^^^^^01f6c3% 🛃   \:customs:  Customs
  ^^^^^^01f6c4% 🛄   \:baggage_claim:    Baggage Claim
  ^^^^^^01f6c5% 🛅   \:left_luggage: Left Luggage
  ^^00}
\lst@RestoreCatcodes
\makeatother

    """
    julia_font_tex = path*"/build_latex/notebooks/julia_font.tex"
    open(julia_font_tex, "w") do f
        write(f,juliafont)
    end

    julia_listings_tex = path*"/build_latex/notebooks/julia_listings.tex"
    open(julia_listings_tex, "w") do f
        write(f,julia_listings)
    end

    julia_listings_unicode_tex = path*"/build_latex/notebooks/julia_listings_unicode.tex"
    open(julia_listings_unicode_tex, "w") do f
        write(f,julialistingsunicode)
    end

end
