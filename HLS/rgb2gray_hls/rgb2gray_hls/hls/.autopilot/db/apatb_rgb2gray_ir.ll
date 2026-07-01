; ModuleID = 'C:/Users/LENOVO/HWSW/HLS/rgb2gray_hls/rgb2gray_hls/hls/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"struct.ap_uint<8>" = type { %"struct.ap_int_base<8, false>" }
%"struct.ap_int_base<8, false>" = type { %"struct.ssdm_int<8, false>" }
%"struct.ssdm_int<8, false>" = type { i8 }

; Function Attrs: noinline
define void @apatb_rgb2gray_ir(%"struct.ap_uint<8>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="307200" "maxi" %r, %"struct.ap_uint<8>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="307200" "maxi" %g, %"struct.ap_uint<8>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="307200" "maxi" %b, %"struct.ap_uint<8>"* noalias nocapture nonnull "fpga.decayed.dim.hint"="307200" "maxi" %gray) local_unnamed_addr #0 {
entry:
  %0 = bitcast %"struct.ap_uint<8>"* %r to [307200 x %"struct.ap_uint<8>"]*
  %1 = call i8* @malloc(i64 307200)
  %r_copy = bitcast i8* %1 to [307200 x i8]*
  %2 = bitcast %"struct.ap_uint<8>"* %g to [307200 x %"struct.ap_uint<8>"]*
  %3 = call i8* @malloc(i64 307200)
  %g_copy = bitcast i8* %3 to [307200 x i8]*
  %4 = bitcast %"struct.ap_uint<8>"* %b to [307200 x %"struct.ap_uint<8>"]*
  %5 = call i8* @malloc(i64 307200)
  %b_copy = bitcast i8* %5 to [307200 x i8]*
  %6 = bitcast %"struct.ap_uint<8>"* %gray to [307200 x %"struct.ap_uint<8>"]*
  %7 = call i8* @malloc(i64 307200)
  %gray_copy = bitcast i8* %7 to [307200 x i8]*
  call fastcc void @copy_in([307200 x %"struct.ap_uint<8>"]* nonnull %0, [307200 x i8]* %r_copy, [307200 x %"struct.ap_uint<8>"]* nonnull %2, [307200 x i8]* %g_copy, [307200 x %"struct.ap_uint<8>"]* nonnull %4, [307200 x i8]* %b_copy, [307200 x %"struct.ap_uint<8>"]* nonnull %6, [307200 x i8]* %gray_copy)
  call void @apatb_rgb2gray_hw([307200 x i8]* %r_copy, [307200 x i8]* %g_copy, [307200 x i8]* %b_copy, [307200 x i8]* %gray_copy)
  call void @copy_back([307200 x %"struct.ap_uint<8>"]* %0, [307200 x i8]* %r_copy, [307200 x %"struct.ap_uint<8>"]* %2, [307200 x i8]* %g_copy, [307200 x %"struct.ap_uint<8>"]* %4, [307200 x i8]* %b_copy, [307200 x %"struct.ap_uint<8>"]* %6, [307200 x i8]* %gray_copy)
  call void @free(i8* %1)
  call void @free(i8* %3)
  call void @free(i8* %5)
  call void @free(i8* %7)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_in([307200 x %"struct.ap_uint<8>"]* readonly "unpacked"="0", [307200 x i8]* nocapture "unpacked"="1.0", [307200 x %"struct.ap_uint<8>"]* readonly "unpacked"="2", [307200 x i8]* nocapture "unpacked"="3.0", [307200 x %"struct.ap_uint<8>"]* readonly "unpacked"="4", [307200 x i8]* nocapture "unpacked"="5.0", [307200 x %"struct.ap_uint<8>"]* readonly "unpacked"="6", [307200 x i8]* nocapture "unpacked"="7.0") unnamed_addr #1 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a307200struct.ap_uint<8>.12"([307200 x i8]* %1, [307200 x %"struct.ap_uint<8>"]* %0)
  call fastcc void @"onebyonecpy_hls.p0a307200struct.ap_uint<8>.12"([307200 x i8]* %3, [307200 x %"struct.ap_uint<8>"]* %2)
  call fastcc void @"onebyonecpy_hls.p0a307200struct.ap_uint<8>.12"([307200 x i8]* %5, [307200 x %"struct.ap_uint<8>"]* %4)
  call fastcc void @"onebyonecpy_hls.p0a307200struct.ap_uint<8>.12"([307200 x i8]* %7, [307200 x %"struct.ap_uint<8>"]* %6)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a307200struct.ap_uint<8>"([307200 x %"struct.ap_uint<8>"]* %dst, [307200 x %"struct.ap_uint<8>"]* readonly %src, i64 %num) local_unnamed_addr #2 {
entry:
  %0 = icmp eq [307200 x %"struct.ap_uint<8>"]* %src, null
  %1 = icmp eq [307200 x %"struct.ap_uint<8>"]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond7 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond7, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx8 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [307200 x %"struct.ap_uint<8>"], [307200 x %"struct.ap_uint<8>"]* %src, i64 0, i64 %for.loop.idx8, i32 0, i32 0, i32 0
  %dst.addr.0.0.06 = getelementptr [307200 x %"struct.ap_uint<8>"], [307200 x %"struct.ap_uint<8>"]* %dst, i64 0, i64 %for.loop.idx8, i32 0, i32 0, i32 0
  %3 = load i8, i8* %src.addr.0.0.05, align 1
  store i8 %3, i8* %dst.addr.0.0.06, align 1
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx8, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_out([307200 x %"struct.ap_uint<8>"]* "unpacked"="0", [307200 x i8]* nocapture readonly "unpacked"="1.0", [307200 x %"struct.ap_uint<8>"]* "unpacked"="2", [307200 x i8]* nocapture readonly "unpacked"="3.0", [307200 x %"struct.ap_uint<8>"]* "unpacked"="4", [307200 x i8]* nocapture readonly "unpacked"="5.0", [307200 x %"struct.ap_uint<8>"]* "unpacked"="6", [307200 x i8]* nocapture readonly "unpacked"="7.0") unnamed_addr #3 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a307200struct.ap_uint<8>"([307200 x %"struct.ap_uint<8>"]* %0, [307200 x i8]* %1)
  call fastcc void @"onebyonecpy_hls.p0a307200struct.ap_uint<8>"([307200 x %"struct.ap_uint<8>"]* %2, [307200 x i8]* %3)
  call fastcc void @"onebyonecpy_hls.p0a307200struct.ap_uint<8>"([307200 x %"struct.ap_uint<8>"]* %4, [307200 x i8]* %5)
  call fastcc void @"onebyonecpy_hls.p0a307200struct.ap_uint<8>"([307200 x %"struct.ap_uint<8>"]* %6, [307200 x i8]* %7)
  ret void
}

declare i8* @malloc(i64) local_unnamed_addr

declare void @free(i8*) local_unnamed_addr

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0a307200struct.ap_uint<8>"([307200 x %"struct.ap_uint<8>"]* "unpacked"="0" %dst, [307200 x i8]* nocapture readonly "unpacked"="1.0" %src) unnamed_addr #4 {
entry:
  %0 = icmp eq [307200 x %"struct.ap_uint<8>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a307200struct.ap_uint<8>.8"([307200 x %"struct.ap_uint<8>"]* nonnull %dst, [307200 x i8]* %src, i64 307200)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a307200struct.ap_uint<8>.8"([307200 x %"struct.ap_uint<8>"]* "unpacked"="0" %dst, [307200 x i8]* nocapture readonly "unpacked"="1.0" %src, i64 "unpacked"="2" %num) local_unnamed_addr #2 {
entry:
  %0 = icmp eq [307200 x %"struct.ap_uint<8>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [307200 x i8], [307200 x i8]* %src, i64 0, i64 %for.loop.idx2
  %dst.addr.0.0.06 = getelementptr [307200 x %"struct.ap_uint<8>"], [307200 x %"struct.ap_uint<8>"]* %dst, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %1 = load i8, i8* %src.addr.0.0.05, align 1
  store i8 %1, i8* %dst.addr.0.0.06, align 1
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0a307200struct.ap_uint<8>.12"([307200 x i8]* nocapture "unpacked"="0.0" %dst, [307200 x %"struct.ap_uint<8>"]* readonly "unpacked"="1" %src) unnamed_addr #4 {
entry:
  %0 = icmp eq [307200 x %"struct.ap_uint<8>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a307200struct.ap_uint<8>.15"([307200 x i8]* %dst, [307200 x %"struct.ap_uint<8>"]* nonnull %src, i64 307200)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a307200struct.ap_uint<8>.15"([307200 x i8]* nocapture "unpacked"="0.0" %dst, [307200 x %"struct.ap_uint<8>"]* readonly "unpacked"="1" %src, i64 "unpacked"="2" %num) local_unnamed_addr #2 {
entry:
  %0 = icmp eq [307200 x %"struct.ap_uint<8>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [307200 x %"struct.ap_uint<8>"], [307200 x %"struct.ap_uint<8>"]* %src, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06 = getelementptr [307200 x i8], [307200 x i8]* %dst, i64 0, i64 %for.loop.idx2
  %1 = load i8, i8* %src.addr.0.0.05, align 1
  store i8 %1, i8* %dst.addr.0.0.06, align 1
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

declare void @apatb_rgb2gray_hw([307200 x i8]*, [307200 x i8]*, [307200 x i8]*, [307200 x i8]*)

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_back([307200 x %"struct.ap_uint<8>"]* "unpacked"="0", [307200 x i8]* nocapture readonly "unpacked"="1.0", [307200 x %"struct.ap_uint<8>"]* "unpacked"="2", [307200 x i8]* nocapture readonly "unpacked"="3.0", [307200 x %"struct.ap_uint<8>"]* "unpacked"="4", [307200 x i8]* nocapture readonly "unpacked"="5.0", [307200 x %"struct.ap_uint<8>"]* "unpacked"="6", [307200 x i8]* nocapture readonly "unpacked"="7.0") unnamed_addr #3 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a307200struct.ap_uint<8>"([307200 x %"struct.ap_uint<8>"]* %6, [307200 x i8]* %7)
  ret void
}

declare void @rgb2gray_hw_stub(%"struct.ap_uint<8>"* noalias nocapture nonnull readonly, %"struct.ap_uint<8>"* noalias nocapture nonnull readonly, %"struct.ap_uint<8>"* noalias nocapture nonnull readonly, %"struct.ap_uint<8>"* noalias nocapture nonnull)

define void @rgb2gray_hw_stub_wrapper([307200 x i8]*, [307200 x i8]*, [307200 x i8]*, [307200 x i8]*) #5 {
entry:
  %4 = call i8* @malloc(i64 307200)
  %5 = bitcast i8* %4 to [307200 x %"struct.ap_uint<8>"]*
  %6 = call i8* @malloc(i64 307200)
  %7 = bitcast i8* %6 to [307200 x %"struct.ap_uint<8>"]*
  %8 = call i8* @malloc(i64 307200)
  %9 = bitcast i8* %8 to [307200 x %"struct.ap_uint<8>"]*
  %10 = call i8* @malloc(i64 307200)
  %11 = bitcast i8* %10 to [307200 x %"struct.ap_uint<8>"]*
  call void @copy_out([307200 x %"struct.ap_uint<8>"]* %5, [307200 x i8]* %0, [307200 x %"struct.ap_uint<8>"]* %7, [307200 x i8]* %1, [307200 x %"struct.ap_uint<8>"]* %9, [307200 x i8]* %2, [307200 x %"struct.ap_uint<8>"]* %11, [307200 x i8]* %3)
  %12 = bitcast [307200 x %"struct.ap_uint<8>"]* %5 to %"struct.ap_uint<8>"*
  %13 = bitcast [307200 x %"struct.ap_uint<8>"]* %7 to %"struct.ap_uint<8>"*
  %14 = bitcast [307200 x %"struct.ap_uint<8>"]* %9 to %"struct.ap_uint<8>"*
  %15 = bitcast [307200 x %"struct.ap_uint<8>"]* %11 to %"struct.ap_uint<8>"*
  call void @rgb2gray_hw_stub(%"struct.ap_uint<8>"* %12, %"struct.ap_uint<8>"* %13, %"struct.ap_uint<8>"* %14, %"struct.ap_uint<8>"* %15)
  call void @copy_in([307200 x %"struct.ap_uint<8>"]* %5, [307200 x i8]* %0, [307200 x %"struct.ap_uint<8>"]* %7, [307200 x i8]* %1, [307200 x %"struct.ap_uint<8>"]* %9, [307200 x i8]* %2, [307200 x %"struct.ap_uint<8>"]* %11, [307200 x i8]* %3)
  call void @free(i8* %4)
  call void @free(i8* %6)
  call void @free(i8* %8)
  call void @free(i8* %10)
  ret void
}

attributes #0 = { noinline "fpga.wrapper.func"="wrapper" }
attributes #1 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="copyin" }
attributes #2 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="arraycpy_hls" }
attributes #3 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="copyout" }
attributes #4 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #5 = { "fpga.wrapper.func"="stub" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1}
!llvm.module.flags = !{!2, !3, !4}
!blackbox_cfg = !{!5}

!0 = !{!"AMD/Xilinx clang version 16.0.6"}
!1 = !{!"clang version 7.0.0 "}
!2 = !{i32 2, !"Dwarf Version", i32 4}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{}
