import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType inputType;
  final int maxLines;
  final bool obscureText;
  final VoidCallback? onIconPressed;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.prefixIcon,
    this.validator,
    this.inputType = TextInputType.text,
    this.maxLines = 1,
    this.obscureText = false,
    this.onIconPressed,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.inputType,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      obscureText: widget.obscureText ? _obscure : false,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() => _obscure = !_obscure);
                },
              )
            : widget.onIconPressed != null
                ? IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: widget.onIconPressed,
                  )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;
  final double height;
  final bool isLoading;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width = double.infinity,
    this.height = 56,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[Icon(icon, color: textColor ?? Colors.white), const SizedBox(width: 8)],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor ?? Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final String employeeName;
  final String employeeCode;
  final String department;
  final String branch;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EmployeeCard({
    Key? key,
    required this.employeeName,
    required this.employeeCode,
    required this.department,
    required this.branch,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employeeName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'کد: $employeeCode',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton(
                      itemBuilder: (BuildContext context) => [
                        if (onEdit != null)
                          PopupMenuItem(
                            child: const Text('ویرایش'),
                            onTap: onEdit,
                          ),
                        if (onDelete != null)
                          PopupMenuItem(
                            child: const Text('حذف'),
                            onTap: onDelete,
                          ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.work, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    department,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    branch,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttendanceCard extends StatelessWidget {
  final String employeeName;
  final String checkInTime;
  final String? checkOutTime;
  final String status;

  const AttendanceCard({
    Key? key,
    required this.employeeName,
    required this.checkInTime,
    this.checkOutTime,
    required this.status,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (status) {
      case 'present':
        return AppColors.success;
      case 'absent':
        return AppColors.error;
      case 'late':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case 'present':
        return 'حاضر';
      case 'absent':
        return 'غایب';
      case 'late':
        return 'دیرهنگام';
      case 'early_leave':
        return 'خروج زودهنگام';
      default:
        return 'نامشخص';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  employeeName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employeeName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        'ورود: $checkInTime',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (checkOutTime != null) ...[const SizedBox(width: 8), Text('خروج: $checkOutTime')],
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getStatusLabel(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
