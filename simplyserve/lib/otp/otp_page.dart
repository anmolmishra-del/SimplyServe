import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simplyserve/screen/landing_page/signup/signup_cubit.dart';

class OtpPage extends StatelessWidget {
  final String mobile;
  final SignupCubit cubit;

  OtpPage({super.key, required this.mobile, required this.cubit});

  // --- OTP controllers & focus nodes ---
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  // --- Timer & resend state ---
  final ValueNotifier<int> secondsRemaining = ValueNotifier<int>(30);
  final ValueNotifier<bool> enableResend = ValueNotifier<bool>(false);
  Timer? timer;

  // --- Start the OTP timer ---
  void startTimer() {
    secondsRemaining.value = 30;
    enableResend.value = false;
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining.value == 0) {
        enableResend.value = true;
        t.cancel();
      } else {
        secondsRemaining.value--;
      }
    });
  }

  // --- Resend OTP ---
  void resendOTP(BuildContext context) async {
    startTimer();
    await cubit.sendOtp(context);
  }

  // --- Verify OTP ---
  void verifyOTP(BuildContext context) {
    final otp = controllers.map((c) => c.text).join();
    cubit.verifyOtp(context, otp);
  }

  // --- OTP TextField box ---
  Widget buildOtpBox(int index, BuildContext context) {
    return SizedBox(
      width: 50,
      height: 55,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).requestFocus(focusNodes[index + 1]);
          }
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(focusNodes[index - 1]);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    startTimer(); // start timer immediately when widget builds

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("OTP Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Info text ---
            Text(
              "We have sent a verification code to",
              style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              mobile,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // --- OTP Boxes ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => buildOtpBox(index, context),
              ),
            ),

            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: const Text("Check text messages for your OTP"),
            ),

            // --- Timer + Resend button ---
            ValueListenableBuilder<bool>(
              valueListenable: enableResend,
              builder: (_, canResend, __) {
                return canResend
                    ? TextButton(
                        onPressed: () => resendOTP(context),
                        child: const Text("Resend OTP"),
                      )
                    : ValueListenableBuilder<int>(
                        valueListenable: secondsRemaining,
                        builder: (_, sec, __) => Text(
                          "Resend SMS in $sec s",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
              },
            ),

            const Spacer(),

            // --- Verify button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => verifyOTP(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Verify"),
              ),
            ),

            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Go back to login methods",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
