function L=Cal_stability_likelihood(Measurement,Type,SL,SI,WL,WI)

    switch Type
        case 'Waveform'
           input_str=WI;
           Likelihood_str=WL;
       case 'Stability' 
           input_str=SI;
           Likelihood_str=SL;
    end
    input=input_str.input;
    Likelihood=Likelihood_str.Likelihood;
    [~,I] = pdist2(input,Measurement,'euclidean','Smallest',1); 
    L=Likelihood(I);
end




