import 'package:flutter/material.dart';
import 'package:open_director/Editor/service_locator.dart';
import 'package:open_director/Editor/service/project_service.dart';
import 'package:open_director/Editor/model/project.dart';
import 'package:open_director/Editor/ui/director.dart';

class ProjectEdit extends StatelessWidget {
  final projectService = locator.get<ProjectService>();

  ProjectEdit(Project project) {
    if (project == null) {
      projectService.project = projectService.createNew();
    } else {
      projectService.project = project;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 247, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(93, 86, 250, 1),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 40,
            ),
            // AppLocalizations.of(context).profile
            Text((projectService.project.id == null)
                ? Localizations.localeOf(context).languageCode == 'ur'
                    ? "نئی ویڈیو"
                    : 'New video'
                : 'Edit title'),
          ],
        ),
      ),
      body: _ProjectEditForm(),
      resizeToAvoidBottomInset: true,
    );
  }
}

class _ProjectEditForm extends StatelessWidget {
  final projectService = locator.get<ProjectService>();
  // Neccesary static
  // https://github.com/flutter/flutter/issues/20042
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.08,
            MediaQuery.of(context).size.height * 0.05,
            MediaQuery.of(context).size.width * 0.08,
            MediaQuery.of(context).size.height * 0.5,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  cursorColor: const Color.fromRGBO(93, 86, 250, 1),
                  initialValue: projectService.project.title,
                  maxLength: 75,
                  onSaved: (value) {
                    projectService.project.title = value;
                  },
                  decoration: InputDecoration(
                    labelText:
                        Localizations.localeOf(context).languageCode == 'ur'
                            ? "عنوان"
                            : 'Title',
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(93, 86, 250, 1)),
                    hintText:
                        Localizations.localeOf(context).languageCode == 'ur'
                            ? "اپنے ویڈیو پروجیکٹ کے لیے عنوان درج کریں"
                            : 'Enter a title for your video project',
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(93, 86, 250, 1))),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return Localizations.localeOf(context).languageCode ==
                              'ur'
                          ? "براہ کرم عنوان درج کریں"
                          : 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                TextFormField(
                  cursorColor: const Color.fromRGBO(93, 86, 250, 1),
                  initialValue: projectService.project.description,
                  maxLines: 3,
                  maxLength: 1000,
                  onSaved: (value) {
                    projectService.project.description = value;
                  },
                  decoration: InputDecoration(
                    labelText:
                        Localizations.localeOf(context).languageCode == 'ur'
                            ? "تفصیل (اختیاری)"
                            : 'Description (optional)',
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(93, 86, 250, 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(93, 86, 250, 1))),
                    border: OutlineInputBorder(),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: <
                    Widget>[
                  TextButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(93, 86, 250, 1))),
                    child: Text(
                        Localizations.localeOf(context).languageCode == 'ur'
                            ? "منسوخ کریں"
                            : 'Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(93, 86, 250, 1))),
                    child: Text(
                        Localizations.localeOf(context).languageCode == 'ur'
                            ? "ٹھیک ہے"
                            : 'OK'),
                    onPressed: () async {
                      // If the form is valid
                      if (_formKey.currentState.validate()) {
                        // To call onSave in TextFields
                        _formKey.currentState.save();

                        // To hide soft keyboard
                        FocusScope.of(context).requestFocus(FocusNode());

                        if (projectService.project.id == null) {
                          await projectService.insert(projectService.project);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DirectorScreenFirstTime(
                                    projectService.project)),
                          );
                        } else {
                          await projectService.update(projectService.project);
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        // To hide soft keyboard
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }
}
