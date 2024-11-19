import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'contact.dart';
import 'viewdata.dart'; // Assuming you have a Contact model class

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  DateTime? selectedDate;
  List<Contact> contactList = []; // Changed to a more descriptive name
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'To Do List',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildTextField('Enter Your Name', nameController),
            _buildTextField('Enter Your Email Id', emailController,
                keyboardType: TextInputType.emailAddress),
            _buildTextField('Enter Your Mobile No', phoneController,
                keyboardType: TextInputType.number, maxLength: 10),
            _buildTextField('Enter Your Address', addressController),
            _buildDatePicker(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  // Helper method to create a TextField
  Widget _buildTextField(String hintText, TextEditingController controller,
      {TextInputType? keyboardType, int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for the Date Picker
  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              selectedDate == null
                  ? 'Selected Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'
                  : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Select Date'),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for the Save/Update Buttons
  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              _saveContact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Viewdata(contactList: contactList),
                ),
              );

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save Data'),
          ),
        ),
      ],
    );
  }

  void _saveContact() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String address = addressController.text.trim();
    String date = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        address.isNotEmpty &&
        date.isNotEmpty) {
      setState(() {
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        addressController.clear();
        contactList.add(Contact(
          name: name,
          email: email,
          phone: phone,
          address: address,
          date: date,
        ));
        selectedDate = null; // Reset selected date
      });
    }
  }
}
