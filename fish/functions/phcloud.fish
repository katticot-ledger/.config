function phcloud --wraps='hcloud --context powerhive' --description 'alias phcloud hcloud --context powerhive'
    hcloud --context powerhive $argv
end
