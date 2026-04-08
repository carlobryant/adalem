import 'dart:typed_data';

import 'package:adalem/core/app_constraints.dart';

class PromptDataModel {
  final List<({Uint8List bytes, String mimeType})> files;
  final String title;
  String? description;

  PromptDataModel({
    required this.files,
    required this.title,
    this.description,
    });

  String build() { 
    description = description != null || description!.isNotEmpty ? " Additionally, $description. " : "";
    final String filesLabel = files.isNotEmpty 
    ? files.map((f) => f.mimeType.split('/').last).toSet().join(', ')
    : "file";

    return '''
{{role "system"}}
Extract all readable text from the attached $filesLabel, preserving its structure
(headings, bullets, tables). Only use information explicitly present in the
provided text. Do not infer, extrapolate, or add outside knowledge.

SUMMARIZATION RULE:
If the total word count of the extracted content exceeds ${Constraint.maxPromptSummary} words, apply
extractive summarization:
- Retain sentences that are definitional, enumerate steps or categories, introduce named concepts or acronyms, or contain specific numbers/values
- Remove redundant, transitional, or introductory filler content
- Final output must stay at or under ${Constraint.maxPromptSummary} words

FORMATTING (body field):
Format the body content in markdown using:
- Headers (##, ###) to reflect document structure
- **Bold** and *italics* for emphasis where contextually appropriate
- Tables for structured/comparative data (max 3 columns; convert wider tables to definition lists or grouped bullets)
- Blockquotes (>) for definitions, callouts, or key statements
- Bullet or numbered lists for enumerated items
- Maximum 15 sections/chapters in the output

IMAGES:
- If an image can be meaningfully represented as text (table, list, paragraph,
  blockquote), convert it. Otherwise omit silently (no reference or mention)

ITEMS AND SCENARIOS:
- Generate a minimum of ${Constraint.minPromptItems} items (12 per difficulty level: 1=easy, 2=medium, 3=hard)
  and a minimum of ${Constraint.minPromptScenario} scenario-based questions (6 per difficulty level)
- Items are flashcards/identification questions; answers must be a single word, or short phrase (5 words max) - no full sentences

OUTPUT FORMAT:
Respond only with a valid JSON object. No text before or after it.
Set "title" and "notebook" to empty strings (""); all other fields must be populated 
If no attached files are readable, respond with: {}
$description
Use this exact schema:
{
    "title": "",
    "notebook": "",
    "chapters": {
        "0": {
            "header": "<chapter title>",
            "body": "<markdown content>"
        }
    },
    "items": {
        "0": {
            "text": "This is often viewed as property of an information system or service.",
            "answer": "Availability",
            "difficulty": 2
        },
        "1": {
            "text": "The most important phase of the OODA loop because it influences thoughts.",
            "answer": "Orient",
            "difficulty": 3
        }
    },
    "scenarios": {
        "0": {
            "text": "Wally Bayola signed in a website with his unique email and a password as his credentials. The system then decides what access level is Wally granted, what function in the system currently providing from the IAAA?",
            "options": [
                "Identification",
                "Authentication",
                "Accountability",
                "Authorization"
            ],
            "answer": "Authorization",
            "difficulty": 3
        },
        "1": {
            "text": "An organization is applying multiple layers of security, including a firewall, physical locks, and employee training, to ensure that if one fails, others remain. This is an example of:",
            "options": [
                "CIA Triad",
                "Defense in Depth",
                "PDCA Model",
                "OODA Loop"
            ],
            "answer": "Defense in Depth",
            "difficulty": 2
        }
    } 
}
  ''';
  }
}