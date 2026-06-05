import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingWidgets {
  // Common Input Row with Label and Hint - Now with Controller
  static Widget inputRow(String label, String hint, {TextEditingController? controller, bool readOnly = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        // Change color to a slightly darker shade if readOnly is true
        color: readOnly ? Colors.grey.shade200 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300, width: 0.6),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly, // Prevents keyboard from appearing and editing
        style: GoogleFonts.poppins(
            fontSize: 14,
            // Optional: Change text color slightly to indicate disabled state
            color: readOnly ? Colors.black54 : Colors.black87
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade700),
          hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
        ),
      ),
    );
  }

  // Basic Text Field - Now with Controller
  static Widget textField(String hint, {TextEditingController? controller, bool readOnly = false}) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        // ✅ Change background to light grey when read-only
        color: readOnly ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly, // ✅ This prevents the keyboard from opening
        enabled: !readOnly, // ✅ This prevents user interaction entirely
        style: GoogleFonts.poppins(
            fontSize: 14,
            color: readOnly ? Colors.grey.shade700 : Colors.black
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: hint,
          labelStyle: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 13),
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 13),
        ),
      ),
    );
  }

  // Row for the Fee Table (Display only, usually doesn't need a controller)
  static Widget feeRow(String head, String fee, String actualFee) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(head, style: GoogleFonts.poppins(fontSize: 13))),
          Expanded(flex: 2, child: Text(fee, style: GoogleFonts.poppins(fontSize: 13))),
          Expanded(
            flex: 2,
            child: Text(
              actualFee,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // Input field with a Top Label - Now with Controller
  static Widget inputField(
      String label,
      String hint,
      {bool filled = false,
        TextEditingController? controller,
        bool readOnly = false} // Added readOnly parameter
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: filled ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly, // Use the parameter here
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(fontSize: 14, color: readOnly ? Colors.grey.shade700 : Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
  // Dropdown with a Top Label (Usually handled via a state variable, not a controller)
  static Widget dropdownField(String label, String value, {ValueChanged<String?>? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: const [
                DropdownMenuItem(value: "Cash", child: Text("Cash")),
                DropdownMenuItem(value: "Online", child: Text("Online")),
                DropdownMenuItem(value: "Card", child: Text("Card")),
              ],
              onChanged: onChanged, // Passed onChanged callback
            ),
          ),
        ),
      ],
    );
  }
}