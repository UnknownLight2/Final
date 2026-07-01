# 2026-06-29T16:33:08.429476400
import vitis

client = vitis.create_client()
client.set_workspace(path="HLS")

vitis.dispose()

