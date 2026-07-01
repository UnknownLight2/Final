# 2026-06-29T16:34:15.671975900
import vitis

client = vitis.create_client()
client.set_workspace(path="HLS")

comp = client.create_hls_component(name = "rgb2gray_hls",cfg_file = ["hls_config.cfg"],template = "empty_hls_component")

cfg = client.get_config_file(path="C:\Users\LENOVO\HWSW\HLS\rgb2gray_hls\hls_config.cfg")

cfg.set_values(key="syn.file", values=["rgb2gray.cpp"])

cfg.set_values(key="tb.file", values=["tb_rgb2gray.cpp"])

comp = client.get_component(name="rgb2gray_hls")
comp.run(operation="C_SIMULATION")

comp.run(operation="SYNTHESIS")

cfg = client.get_config_file(path="/c:/Users/LENOVO/HWSW/HLS/rgb2gray_hls/hls_config.cfg")

cfg.set_value(section="hls", key="syn.top", value="syn.top=rgb2gray")

cfg.set_value(section="hls", key="syn.top", value="rgb2gray")

comp.run(operation="SYNTHESIS")

comp.run(operation="CO_SIMULATION")

comp.run(operation="PACKAGE")

comp.run(operation="C_SIMULATION")

comp.run(operation="SYNTHESIS")

comp.run(operation="CO_SIMULATION")

comp.run(operation="PACKAGE")

vitis.dispose()

