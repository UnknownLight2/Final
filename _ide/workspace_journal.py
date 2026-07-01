# 2026-06-29T16:31:07.229285800
import vitis

client = vitis.create_client()
client.set_workspace(path="HWSW")

vitis.dispose()

