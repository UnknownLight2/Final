// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xrgb2gray.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XRgb2gray_CfgInitialize(XRgb2gray *InstancePtr, XRgb2gray_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XRgb2gray_Start(XRgb2gray *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_AP_CTRL) & 0x80;
    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XRgb2gray_IsDone(XRgb2gray *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XRgb2gray_IsIdle(XRgb2gray *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XRgb2gray_IsReady(XRgb2gray *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XRgb2gray_EnableAutoRestart(XRgb2gray *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XRgb2gray_DisableAutoRestart(XRgb2gray *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_AP_CTRL, 0);
}

void XRgb2gray_Set_r(XRgb2gray *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_R_DATA, (u32)(Data));
    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_R_DATA + 4, (u32)(Data >> 32));
}

u64 XRgb2gray_Get_r(XRgb2gray *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_R_DATA);
    Data += (u64)XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_R_DATA + 4) << 32;
    return Data;
}

void XRgb2gray_Set_g(XRgb2gray *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_G_DATA, (u32)(Data));
    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_G_DATA + 4, (u32)(Data >> 32));
}

u64 XRgb2gray_Get_g(XRgb2gray *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_G_DATA);
    Data += (u64)XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_G_DATA + 4) << 32;
    return Data;
}

void XRgb2gray_Set_b(XRgb2gray *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_B_DATA, (u32)(Data));
    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_B_DATA + 4, (u32)(Data >> 32));
}

u64 XRgb2gray_Get_b(XRgb2gray *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_B_DATA);
    Data += (u64)XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_B_DATA + 4) << 32;
    return Data;
}

void XRgb2gray_Set_gray(XRgb2gray *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_GRAY_DATA, (u32)(Data));
    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_GRAY_DATA + 4, (u32)(Data >> 32));
}

u64 XRgb2gray_Get_gray(XRgb2gray *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_GRAY_DATA);
    Data += (u64)XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_GRAY_DATA + 4) << 32;
    return Data;
}

void XRgb2gray_InterruptGlobalEnable(XRgb2gray *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_GIE, 1);
}

void XRgb2gray_InterruptGlobalDisable(XRgb2gray *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_GIE, 0);
}

void XRgb2gray_InterruptEnable(XRgb2gray *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_IER);
    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_IER, Register | Mask);
}

void XRgb2gray_InterruptDisable(XRgb2gray *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_IER);
    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_IER, Register & (~Mask));
}

void XRgb2gray_InterruptClear(XRgb2gray *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRgb2gray_WriteReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_ISR, Mask);
}

u32 XRgb2gray_InterruptGetEnabled(XRgb2gray *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_IER);
}

u32 XRgb2gray_InterruptGetStatus(XRgb2gray *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XRgb2gray_ReadReg(InstancePtr->Control_BaseAddress, XRGB2GRAY_CONTROL_ADDR_ISR);
}

