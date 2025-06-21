import 'dart:io';
import '../../../../controller/teacher_home_result_controller.dart';
import '../../../../data/consts/const_import.dart';
import '../../../../data/custom_widget/app_custom_button.dart';
import '../../../../data/custom_widget/custom_text_field.dart';

class CreateResultFormView extends StatelessWidget {
  const CreateResultFormView({
    super.key,
    required this.controller,
  });

  final ResultController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: 'Create Result',
              color: blackColor,
              fontWeight: FontWeight.bold,
              size: 22,),
            SizedBox(height: 15,),
            CustomText(text: 'Submit logo of your school',
              color: blackColor,
              fontWeight: FontWeight.w400,
              size: 17,),
            SizedBox(height: 5,),
            Obx(() =>
                CustomCard(
                  onTap: () => controller.pickImage(controller.schoolLogo),
                  borderRadius: 5,
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: controller.schoolLogo.value.isEmpty
                      ? Icon(Icons.image)
                      : controller.schoolLogo.value.startsWith('http')
                      ? Image.network(controller.schoolLogo.value, fit: BoxFit.cover)
                      : Image.file(File(controller.schoolLogo.value), fit: BoxFit.cover),

                )),
            SizedBox(height: 16),
            CustomCard(
              borderRadius: 5,
              color: Colors.grey[300],
              child: CustomTextFormField(
                borderColor: Colors.transparent,
                hintText: 'Contact Number',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                controller: controller.contactNumberController,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
            ),
            SizedBox(height: 10,),
            CustomCard(
              borderRadius: 5,
              color: Colors.grey[300],
              child: CustomTextFormField(
                borderColor: Colors.transparent,
                hintText: 'Alternative number of school',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                controller: controller.alternativeNumberSchoolController,
              ),
            ),
            SizedBox(height: 10,),
            CustomCard(
              borderRadius: 5,
              color: Colors.grey[300],
              child: CustomTextFormField(
                borderColor: Colors.transparent,
                hintText: 'Website Link',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                controller: controller.websiteLinkController,
              ),
            ),
            SizedBox(height: 10,),
            CustomCard(
              borderRadius: 5,
              color: Colors.grey[300],
              child: CustomTextFormField(
                borderColor: Colors.transparent,
                hintText: 'School Address',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                controller: controller.schoolAddressController,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(height: 16),
            CustomText(text: 'Class Teacher Signature',
              color: blackColor,
              fontWeight: FontWeight.w400,
              size: 17,),
            SizedBox(height: 5,),
            Obx(() {
              final path = controller.classTeacherSignature.value;
              return CustomCard(
                onTap: () =>
                    controller.pickImage(controller.classTeacherSignature),
                borderRadius: 5,
                height: 150,
                width: double.infinity,
                color: Colors.grey[300],
                child: path.isEmpty
                    ? Icon(Icons.image)
                    : path.startsWith('http')
                    ? Image.network(path, fit: BoxFit.cover)
                    : Image.file(File(path), fit: BoxFit.cover),
              );
            },),
            SizedBox(height: 16),
            CustomText(text: 'Principal Signature',
              color: blackColor,
              fontWeight: FontWeight.w400,
              size: 17,),
            SizedBox(height: 5,),
            Obx(() {
              final path = controller.principalSignature.value;
              return CustomCard(
                onTap: () => controller.pickImage(controller.principalSignature),
                borderRadius: 5,
                height: 150,
                width: double.infinity,
                color: Colors.grey[300],
                child: path.isEmpty
                    ? Icon(Icons.image)
                    : path.startsWith('http')
                    ? Image.network(path, fit: BoxFit.cover)
                    : Image.file(File(path), fit: BoxFit.cover),
              );
            }),

            SizedBox(height: 24),
            Obx(() =>
            controller.isLoading.value ? Center(child: CircularProgressIndicator()) : controller.isEditing.value  ? AppCustomButton(
              text: 'Update Result',
              onTap: controller.updateSchool,
            ) : AppCustomButton(
              text: 'Create Result',
              onTap: controller.submitData,
            ))
          ],
        ),
      ),
    );
  }
}