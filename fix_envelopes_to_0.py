import sys

with open("src-unified/mc004.asm", "r") as f:
    text = f.read()

text = text.replace(".envs_to_do\tSKIP\t1", "\tIF BUILD_MASTER\n.envs_to_do\tSKIP\t1")
text = text.replace(".last_env\tSKIP\t1\n\n;****************************************", ".last_env\tSKIP\t1\n\tENDIF\n\n;****************************************")

with open("src-unified/mc004.asm", "w") as f:
    f.write(text)
