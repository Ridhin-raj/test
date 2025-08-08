import 'package:altwrong/service/gemini_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final questionController = TextEditingController();
  String? funnyAnswer;
  bool isLoading = false;

  Future<void> _askBadvice() async {
    final question = questionController.text.trim();
    if(question.isEmpty){

       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a question first."),
          backgroundColor: Colors.red,
        ),
      );
      return;

    }

    setState(()=> isLoading = true);
    
    try {
      final response = await GeminiService.getFunnyAnswer(question);
      setState(() => funnyAnswer = response);
    

    //  save to Firestore
    await FirebaseFirestore.instance.collection('bad vice').add({
      'question' : question,
      'answer' : response,
      'timestamp': FieldValue.serverTimestamp(),
    }
   
    );
    setState(() => isLoading = false);
    } catch (e) {
      // ✅ 4. Handle any errors from API or Firestore
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // ✅ 5. Stop loading in all cases
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Altwrong"),),
      body: Padding(padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: questionController,
            decoration: InputDecoration(
              labelText: 'Ask your question...',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          ElevatedButton(onPressed: _askBadvice, 
          child: isLoading ? CircularProgressIndicator(
            color: Colors.white,
          ):Text("Get Badvice!"),
          
          ),
          SizedBox(
            height: 24,
          ),
          if (funnyAnswer!= null)
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(8),

            ),
            child: Text(
              funnyAnswer!,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          )
        ],
      ),),
    );
  }
}
