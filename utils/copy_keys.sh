#/bin/bash
mkdir -p $PWD/keys
if stat -t $HOME/.ssh/*.pub >/dev/null 2>&1
then
    for filename in $HOME/.ssh/*.pub; do
        cp "$filename" $PWD/keys
        echo $filename coped 
    done
else
    echo not found any pub keys
fi
