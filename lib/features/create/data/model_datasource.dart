class PromptDataModel {
  final List<String> filetype;
  final String title;
  String? description;

  PromptDataModel({
    required this.filetype,
    required this.title,
    this.description,
    });

  String build() {
    if(filetype.isEmpty) {
      return '''
{{role "system"}}
Create a study material for newbies to Rust programming with a minumum of of 36 items (for quiz/flashcard, 12 per difficulty: 1-easy, 2-medium, 3-hard) and a minimum of 18 scenario type questions (6 per difficulty).
FORMATTING (body field):
Format the body content in markdown using:
- Headers (##, ###) to reflect document structure
- **Bold** and *italics* for emphasis where contextually appropriate
- Tables for structured/comparative data
- Blockquotes (>) for definitions, callouts, or key statements
- Bullet or numbered lists for enumerated items
- Maximum 15 sections/chapters in the output
OUTPUT FORMAT:
Respond only with a valid JSON object. No text before or after it.
Use this exact schema:
{
    "title": "Information Assurance and Security",
    "notebook": "Op5NfX6SWTPA6m3osmFc",
    "chapters": {
        "0": {
            "header": "Information Assurance Introduction",
            "body": "## Defense in Depth \\n* Defense layer must be composed of multiple countermeasures.\\n* Provides an adequate information assurance.\\n* Relies heavily on segmentation.\\n* Characteristics of Defense-in-depth strategy: \\n    * Self-organizing \\n    * Adapting \\n    * Evolving \\n    * Reactive \\n    * Proactive \\n    * Harmonious \\n\\n\\n\\n## The CIA Triad \\nDealing with information security and its subcomponent, the CIA triad should be present.\\n* Used to identify problems and provide proper solutions.\\n\\n### Confidentiality \\n* Aims at preventing information leakage to unauthorized recipients.\\n    * Example: Transmission between conversations must be encrypted.\\n* Confidentiality breach: Can be violated from inappropriate disposal of documents containing social security numbers.\\n* It is the assurance of data secrecy.\\n    * Example: No one is able to read data except for the intended entity.\\n* Confidentiality should prevail no matter what the data state is.\\n* Privacy involves personal autonomy and control of information about oneself.\\n* Classification merely means categorization in certain industries.\\n    * Example: Categorization in the military – unclassified, confidential, secret, and top secret.\\n\\n### Integrity \\n* Aims at preventing information corruption.\\n* Corruption is unauthorized modification of information by an agent (a person, a virus, or a system).\\n    * Example: File corruption (modified or deleted by a virus infection).\\n* It provides assurance of the accuracy of the data.\\n* Integrity controls: Watermarks, bar codes, hashing, checksums, and cyclic redundancy check (CRC).\\n\\n### Availability \\n* The service that assures data and resources are accessible to authorized subjects or personnel when required.\\n    * Example: Systems and networks should provide sufficient capacity to perform in a predictable and acceptable manner.\\n* Often viewed as a property of an information system or service.\\n\\n\\n\\n---\\n\\n## Non-repudiation and Authentication \\n\\n### Non-repudiation \\n> Legal Concept: Can only be solved through legal and social processes.\\n* Describes the service that ensures entities are honest in their actions.\\n* Implies that both ends of a transmission cannot deny their involvement in this transmission.\\n\\n### Authentication \\n> Technical Concept: Can be solved through cryptography.\\n* A mechanism designed to verify the identity of an agent, human, or system before access is granted.\\n    * Example: Username and password authentication, PKI.\\n\\n---\\n\\n## IAAA (Access Management System) \\n* IAAA are essential functions in providing an access management system.\\n* Summarized as the authentication service as described by the MSR model.\\n* The current industry practice for implementing IAAA security is identity management.\\n    * Example: The use of logon IDs and passwords.\\n\\n### The IAAA Process\\n1. IDENTIFICATION (I am a user of the system) \\n    * A method for a user within a system to introduce oneself.\\n    * Identifiers must be unique so that a user can be accurately identified across the organization.\\n    * Each user should have a unique identifier, even if performing multiple roles.\\n2. AUTHENTICATION (I can prove I’m a user of the system) \\n    * Validates the identification provided by a user.\\n    * Most organizations require a second credential for the entity to be authenticated.\\n    * Three basic authentication factors: Something you know, something you have, and something you are (or can produce).\\n3. AUTHORIZATION (Here’s what I can do with the system) \\n    * The matching of an authenticated entity to a list of information assets and corresponding access levels.\\n    * Ways to handle authorization: Authenticated user, members of a group, or across multiple systems.\\n4. ACCOUNTABILITY \\n    * The act of being responsible for actions taken within the system.\\n    * The only way to ensure accountability is to identify the user and record their action.\\n\\n\\n\\n---\\n\\n## Assets, Threats, Vulnerabilities, Risks, and Controls \\n* The combination of vulnerabilities and threats contributes to risk.\\n\\n* Assets: \\n    * Anything valuable to the organization.\\n    * Can be tangible (hardware) or intangible (data, services, and people).\\n* Threats: \\n    * Potential events that may cause the loss of an information asset.\\n    * May be natural, deliberate, or accidental.\\n* Vulnerabilities: \\n    * Weaknesses within the information asset that are exploited by threats.\\n* Risks: \\n    * Expresses the chance of something happening (likelihood ).\\n* Controls: \\n    * Actions or mechanisms established to resolve information assurance issues.\\n    * Categories: Management, Operational, and Technical controls.\\n\\n### Common Threats \\n* Errors and Negligence: Programming bugs , typographical errors , misconfigured systems.\\n* Fraudulent and Theft Activities \\n* Loss of Infrastructure \\n* Malware \\n* Attackers: Elite hackers, script writers, and script kiddies.\\n* Hacker Types: White-hat, Black-hat, and Gray-hat.\\n\\n---\\n\\n## Information Life Cycle \\nCyclical stages: Create -> Process -> Use/Transmit/Store -> Retain -> Dispose \\n* Create: Information is generated internally.\\n* Process: Data is processed to meet organizational goals.\\n* Store: Results are saved for later use.\\n* Retain: Information is kept as part of legal requirements.\\n* Dispose: Information is destroyed if the organization has no use for it.\\n\\n\\n\\n---\\n\\n## Plan-Do-Check-Act Model (PDCA) \\n* Implementation of a continuous improvement process for an effective IAMS.\\n* ISO/IEC 27000 is the specification standard for this model.\\n\\n* Plan: Establish the IAMS; focuses on documenting policy, scope, and risk approach.\\n* Do: Implement, operate, and maintain the IAMS; put controls into practice.\\n* Check: Monitor and review the IAMS; assess performance and conduct audits.\\n* Act: Execute, maintain, and improve the IAMS; implement corrective actions.\\n\\n---\\n\\n## Boyd’s OODA Loop \\nDeveloped by U.S. Air Force Colonel John Boyd to describe strategic operations.\\n\\n1. Observe: Gather raw information about the situation.\\n2. Orient: The most important phase; inherently influences thoughts and can confuse adversaries.\\n3. Decide: Based on the orientation, a decision is made to act.\\n4. Act: The action is performed."
        },
        "1": {
            "header": "Approaches to Implementing Information Assurance",
            "body": "## Information Assurance Program\\n* In implementing an information assurance program, the approach taken also plays an important role. \\n* Sometimes a hybrid is the right decision in selecting a suitable approach. \\n* Top-down approach: used to match general corporate security requirements. \\n* Bottom-up approach: used at the same time to meet local security requirements within specific economies. \\n\\n\\n\\n---\\n\\n## Key Components of IA Approaches\\n* People\\n    * People are a challenging and crucial resource that need management. \\n    * By applying the right processes and technology, people add value to organizations. \\n    * Awareness, training, and education (AT&E) are key to making information assurance work. \\n* Process\\n    * Refers to the use of a formalized sequence of actions to achieve an aim. \\n* Technology\\n    * The hardware and software tools used to implement and enforce security. \\n\\n---\\n\\n## Level of Controls in an IA Program\\n\\n\\n\\n### Strategic Management\\n> Includes security processes such as conducting risk management exercises, security awareness programs, policy development, and compliance efforts with laws and regulations. \\n\\n### Tactical Management\\n> Examines business continuity, data classification, process management, personnel security, and risk management. \\n\\n### Operational Management\\n> Includes areas of communication security, security of an information system life cycle, and incident response."
        },
        "2": {
            "header": "Organizational Structure for Managing Information Assurance",
            "body": "## Organizational Structure for Managing Information Assurance\\n\\n> “Information Assurance is everyone’s responsibility” \\n\\nAn organizational structure is a system that outlines how certain activities are directed in order to achieve the goals of an organization.\\n\\n### Importance of IA Organizational Structure\\n* Continuous support and commitment from top management.\\n* Involvement of employees in the planning of local security systems.\\n* Executives’ better understanding of the organization.\\n* Secure management of information assets by the organization.\\n* Managers become more aware and familiar with specific security requirements.\\n* Secured physical and logical access to IT infrastructure.\\n\\n### IA Structure Types\\n\\n\\n\\n* HYBRID Structure:\\n    * IA program is managed under a centralized unit.\\n    * Roles, responsibilities, and authorities are spread throughout the organization.\\n    * A functional mix of both centralized and distributed structures.\\n\\n---\\n\\n## Roles and Responsibilities\\n\\n### Senior Management\\n* Establishes and enforces the organization's information assurance program.\\n* Endorses and approves policies and objectives supporting the vision and mission.\\n\\n### Executive Leadership\\n* Chief Executive Officer (CEO):\\n    * The highest-level senior official with overall responsibility for IA protections.\\n    * Ensures IA management processes are integrated with strategic and operational planning.\\n    * Ensures senior officials provide IA for systems under their control and that personnel are sufficiently trained.\\n* Chief Risk Officer (CRO):\\n    * Holds the risk executive functional role; provides an organization-wide approach to risk management."
        },
        "3": {
            "header": "Asset Management",
            "body": "## Asset Management\\n\\n> “A best-practice security risk assessment exercise begins with an identification of the assets…” \\n\\n### Asset Definition\\nAn asset is a resource with economic value that an individual, corporation, or country owns or controls with the expectation that it will provide a future benefit. \\n\\n### Types of Assets\\n* Tangible assets: Range from data files to physical assets, such as computer peripherals. \\n* Intangible assets: Include the image and reputation of the organization, general utilities, and skill sets of a workforce. \\n\\n---\\n\\n## ISO/IEC 27000 Series and Asset Management\\n* The ISO/IEC 27000 series is a set of standards for Information Security Management Systems (ISMS) that provides a framework for managing security risks and protecting information assets. \\n* Key standards include ISO/IEC 27001 (Requirements), ISO/IEC 27002 (Best Practices), and ISO/IEC 27005 (Risk Management). \\n* Asset management in this series focuses on identifying, classifying, and protecting information assets to mitigate security risks. \\n\\n### Asset Categories and Examples\\n| Category | Examples |\\n| :--- | :--- |\\n| Data/information | Databases, personnel records, proposals, contracts, manuals, statistics.  |\\n| Hardware | Computer/network equipment, tape, removable media.  |\\n| Intangible | Reputation, image, influence, intellectual property.  |\\n| People | Staff with expertise, skill, and knowledge on a subject.  |\\n| Service | Electricity, telecommunication service, lighting.  |\\n| Software | Application software, system software, system utility, development tool. |\\n\\n---\\n\\n## Importance and Key Components\\n\\n### Importance\\n* Proper asset management protects critical data and intellectual property. \\n* Ensures legal and regulatory compliance. \\n* Reduces breach risks and unauthorized access. \\n* Ensures business continuity and disaster recovery. \\n\\n### Key Components\\n* Asset Identification: Cataloging all information assets including data, software, hardware, networks, and personnel. \\n* Asset Classification: Assigning value and sensitivity levels to determine protection levels and access controls. \\n* Asset Ownership: Defining who is accountable and responsible for each asset. \\n* Asset Handling and Protection: Implementing security controls like Access Control (RBAC), encryption, and monitoring. \\n* Asset Disposal: Securely removing assets when no longer needed to prevent data leaks. \\n\\n---\\n\\n## Management Processes\\n\\n### Identification Methods\\n* Inventory tracking tools. \\n* Network discovery techniques. \\n* Manual audits and documentation. \\n\\n### Common Classifications\\n1. Public: No restrictions. \\n2. Internal: For internal use only. \\n3. Confidential: Restricted access. \\n4. Highly Sensitive: Strictly controlled access.\\n\\n### Roles in Asset Management\\n* Asset Owners: Accountable for managing and protecting assigned assets. \\n* Custodians: Responsible for maintaining and securing assets. \\n* Users: Must follow security policies and guidelines. \\n\\n### Disposal Best Practices\\n* Data wiping: Overwriting storage before disposal. \\n* Physical destruction: Shredding or degaussing. \\n* Secure recycling: Secure transfer or donation. \\n\\n### Risk Management Strategies\\n* Avoid: Eliminate the asset or risk. \\n* Mitigate: Apply security controls. \\n* Transfer: Through insurance or outsourcing. \\n* Accept: Based on business needs. \\n\\n### ISO/IEC 27001 Compliance\\nISO/IEC 27001 requires organizations to:\\n1. Define an asset management policy. \\n2. Maintain an inventory of assets. \\n3. Assign ownership and define security measures. \\n4. Conduct regular risk assessments and audits. "
        }
    },
    "items": {
        "0": {
            "text": "The C in CIA Triad stands for?",
            "answer": "Confidentiality",
            "difficulty": 1
        },
        "1": {
            "text": "This is often viewed as property of an information system or service.",
            "answer": "Availability",
            "difficulty": 2
        },
        "2": {
            "text": "Defense in depth relies heavily on this for architectural isolation.",
            "answer": "Segmentation",
            "difficulty": 2
        },
        "3": {
            "text": "The process of verifying a user's identity through technical means like cryptography.",
            "answer": "Authentication",
            "difficulty": 2
        },
        "4": {
            "text": "This component of CIA ensures that information has not been unauthorizedly modified.",
            "answer": "Integrity",
            "difficulty": 1
        },
        "5": {
            "text": "Examples of this CIA control include hashing, checksums, and CRC.",
            "answer": "Integrity controls",
            "difficulty": 2
        },
        "6": {
            "text": "This concept ensures both ends of a transmission cannot deny their involvement.",
            "answer": "Non-repudiation",
            "difficulty": 2
        },
        "7": {
            "text": "The act of a user introducing themselves to a system.",
            "answer": "Identification",
            "difficulty": 1
        },
        "8": {
            "text": "Matching an authenticated entity to access levels for information assets.",
            "answer": "Authorization",
            "difficulty": 2
        },
        "9": {
            "text": "The combination of vulnerabilities and threats contributes to this.",
            "answer": "Risk",
            "difficulty": 2
        },
        "10": {
            "text": "Anything valuable to the organization, whether tangible or intangible.",
            "answer": "Asset",
            "difficulty": 1
        },
        "11": {
            "text": "Weaknesses within an information asset that are exploited by threats.",
            "answer": "Vulnerabilities",
            "difficulty": 2
        },
        "12": {
            "text": "The probability of a particular risk occurring.",
            "answer": "Likelihood",
            "difficulty": 2
        },
        "13": {
            "text": "These controls relate to management, operational, and technical mechanisms.",
            "answer": "Categories of controls",
            "difficulty": 2
        },
        "14": {
            "text": "The first stage of the Information Life Cycle.",
            "answer": "Create",
            "difficulty": 1
        },
        "15": {
            "text": "The final stage of the Information Life Cycle where data is securely destroyed.",
            "answer": "Dispose",
            "difficulty": 1
        },
        "16": {
            "text": "The PDCA phase where policy, scope, and risk approach are documented.",
            "answer": "Plan",
            "difficulty": 2
        },
        "17": {
            "text": "The phase of the OODA loop that gather raw information about the situation.",
            "answer": "Observe",
            "difficulty": 2
        },
        "18": {
            "text": "The most important phase of the OODA loop because it influences thoughts.",
            "answer": "Orient",
            "difficulty": 3
        },
        "19": {
            "text": "The IA structure importance stating it is everyone's responsibility.",
            "answer": "Organizational Structure for Managing Information Assurance",
            "difficulty": 2
        },
        "20": {
            "text": "An IA structure that spreads roles and authorities throughout the organization under a centralized unit.",
            "answer": "Hybrid Structure",
            "difficulty": 2
        },
        "21": {
            "text": "The role that establishes and enforces the organization's IA program.",
            "answer": "Senior Management",
            "difficulty": 2
        },
        "22": {
            "text": "Highest-level official with overall responsibility for IA protections.",
            "answer": "Chief Executive Officer (CEO)",
            "difficulty": 1
        },
        "23": {
            "text": "Role that provides an organization-wide approach to risk management.",
            "answer": "Chief Risk Officer (CRO)",
            "difficulty": 2
        },
        "24": {
            "text": "Role that designates a senior information security officer and develops policies.",
            "answer": "Chief Information Officer (CIO)",
            "difficulty": 2
        },
        "25": {
            "text": "Primary liaison for the CIO who administers security program functions.",
            "answer": "Chief Information Security Officer (CISO)",
            "difficulty": 2
        },
        "26": {
            "text": "Official who accepts responsibility for unmitigated risks and can halt operations.",
            "answer": "Accrediting Official (AO)",
            "difficulty": 3
        },
        "27": {
            "text": "Conducts comprehensive assessments to see if controls are operating as intended.",
            "answer": "Information Assurance Control Assessor (IACA)",
            "difficulty": 2
        },
        "28": {
            "text": "Role that captures and refines IA requirements into IT products.",
            "answer": "Information Assurance Engineer (IAE)",
            "difficulty": 2
        },
        "29": {
            "text": "Role that serves as a liaison between the enterprise architect and IA engineer.",
            "answer": "Information Assurance Architect (IAA)",
            "difficulty": 3
        },
        "30": {
            "text": "Principal advisor on all matters involving the assurance of an information system.",
            "answer": "Information System Security Officer (ISSO)",
            "difficulty": 2
        },
        "31": {
            "text": "Official responsible for the full life cycle of a specific system from procurement to disposal.",
            "answer": "Information System Owner",
            "difficulty": 2
        },
        "32": {
            "text": "Responsible for the development and monitoring of shared/common controls.",
            "answer": "Common Control Provider (CCP)",
            "difficulty": 2
        },
        "33": {
            "text": "A resource with economic value owned with the expectation of future benefit.",
            "answer": "Asset",
            "difficulty": 1
        },
        "34": {
            "text": "Examples include reputation, image, and skill sets of a workforce.",
            "answer": "Intangible assets",
            "difficulty": 2
        },
        "35": {
            "text": "ISO standard specifically for ISMS Risk Management.",
            "answer": "ISO/IEC 27005",
            "difficulty": 3
        },
        "36": {
            "text": "The process of cataloging all hardware, software, and personnel assets.",
            "answer": "Asset Identification",
            "difficulty": 2
        },
        "37": {
            "text": "Assigning levels like 'Confidential' or 'Public' based on sensitivity.",
            "answer": "Asset Classification",
            "difficulty": 1
        },
        "38": {
            "text": "The person accountable for managing and protecting assigned assets.",
            "answer": "Asset Owner",
            "difficulty": 2
        },
        "39": {
            "text": "Best practice involving overwriting storage before disposal.",
            "answer": "Data wiping",
            "difficulty": 2
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
        },
        "2": {
            "text": "A bank discovers that a virus has modified several transaction records without authorization. Which pillar of the CIA triad has been violated?",
            "options": [
                "Confidentiality",
                "Integrity",
                "Availability",
                "Non-repudiation"
            ],
            "answer": "Integrity",
            "difficulty": 2
        },
        "3": {
            "text": "During a regional outage, an e-commerce site remains up and running because of its redundant server setup. This maintains which security property?",
            "options": [
                "Authentication",
                "Confidentiality",
                "Integrity",
                "Availability"
            ],
            "answer": "Availability",
            "difficulty": 2
        },
        "4": {
            "text": "An IT manager is creating a document that outlines the specific security policy and scope of the management system. According to the PDCA model, which phase is this?",
            "options": [
                "Plan",
                "Do",
                "Check",
                "Act"
            ],
            "answer": "Plan",
            "difficulty": 2
        },
        "5": {
            "text": "A military commander is gathering raw data about enemy movements to prepare for a response. According to Boyd's model, which phase is being performed?",
            "options": [
                "Observe",
                "Orient",
                "Decide",
                "Act"
            ],
            "answer": "Observe",
            "difficulty": 2
        },
        "6": {
            "text": "An organization uses a structure where IA roles are spread across different departments, but there is a central unit that coordinates the entire program. What is this structure?",
            "options": [
                "Centralized",
                "Distributed",
                "Hybrid",
                "Segmented"
            ],
            "answer": "Hybrid",
            "difficulty": 2
        },
        "7": {
            "text": "A high-level official is tasked with signing off on a new information system despite knowing there are some minor unmitigated risks. Who is this?",
            "options": [
                "CISO",
                "Accrediting Official (AO)",
                "IA Architect",
                "Common Control Provider"
            ],
            "answer": "Accrediting Official (AO)",
            "difficulty": 3
        },
        "8": {
            "text": "A company is disposing of old hard drives. To prevent data leaks, they use a machine to physically shred the platters. This is a best practice of:",
            "options": [
                "Asset Identification",
                "Asset Classification",
                "Asset Disposal",
                "Asset Ownership"
            ],
            "answer": "Asset Disposal",
            "difficulty": 2
        },
        "9": {
            "text": "A security team decides to buy cyber-insurance to cover potential losses from a breach rather than spending more on internal firewalls. What risk strategy is this?",
            "options": [
                "Avoid",
                "Mitigate",
                "Transfer",
                "Accept"
            ],
            "answer": "Transfer",
            "difficulty": 3
        }
    } 
}
''';
    }
    description = description != null || description!.isNotEmpty ? " Additionally, $description. " : "";
    final String filetypes = filetype.isNotEmpty ? filetype.join(', ') : "file";

    return '''
{{role "system"}}
Extract all readable text from the attached $filetypes, preserving its structure
(headings, bullets, tables). Only use information explicitly present in the
provided text. Do not infer, extrapolate, or add outside knowledge.

SUMMARIZATION RULE:
If the total word count of the extracted content exceeds 3,000 words, apply
extractive summarization:
- Retain the most informative sentences, prioritizing those that contain
  numbers, conclusions, key findings, or methodology descriptions
- Remove redundant, transitional, or introductory filler content
- Final output must stay at or under 3,000 words.

FORMATTING (body field):
Format the body content in markdown using:
- Headers (##, ###) to reflect document structure
- **Bold** and *italics* for emphasis where contextually appropriate
- Tables for structured/comparative data
- Blockquotes (>) for definitions, callouts, or key statements
- Bullet or numbered lists for enumerated items
- Maximum 15 sections/chapters in the output

Images:
- If an image can be meaningfully represented as text (table, list, paragraph,
  blockquote), convert it
- If not, omit it entirely — do not reference or mention the skipped image

OUTPUT FORMAT:
Respond only with a valid JSON object. No text before or after it.$description
Use this exact schema:
{
    "title": "Information Assurance and Security",
    "notebook": "Op5NfX6SWTPA6m3osmFc",
    "chapters": {
        "0": {
            "header": "Information Assurance Introduction",
            "body": "## Defense in Depth \\n* Defense layer must be composed of multiple countermeasures.\\n* Provides an adequate information assurance.\\n* Relies heavily on segmentation.\\n* Characteristics of Defense-in-depth strategy: \\n    * Self-organizing \\n    * Adapting \\n    * Evolving \\n    * Reactive \\n    * Proactive \\n    * Harmonious \\n\\n\\n\\n## The CIA Triad \\nDealing with information security and its subcomponent, the CIA triad should be present.\\n* Used to identify problems and provide proper solutions.\\n\\n### Confidentiality \\n* Aims at preventing information leakage to unauthorized recipients.\\n    * Example: Transmission between conversations must be encrypted.\\n* Confidentiality breach: Can be violated from inappropriate disposal of documents containing social security numbers.\\n* It is the assurance of data secrecy.\\n    * Example: No one is able to read data except for the intended entity.\\n* Confidentiality should prevail no matter what the data state is.\\n* Privacy involves personal autonomy and control of information about oneself.\\n* Classification merely means categorization in certain industries.\\n    * Example: Categorization in the military – unclassified, confidential, secret, and top secret.\\n\\n### Integrity \\n* Aims at preventing information corruption.\\n* Corruption is unauthorized modification of information by an agent (a person, a virus, or a system).\\n    * Example: File corruption (modified or deleted by a virus infection).\\n* It provides assurance of the accuracy of the data.\\n* Integrity controls: Watermarks, bar codes, hashing, checksums, and cyclic redundancy check (CRC).\\n\\n### Availability \\n* The service that assures data and resources are accessible to authorized subjects or personnel when required.\\n    * Example: Systems and networks should provide sufficient capacity to perform in a predictable and acceptable manner.\\n* Often viewed as a property of an information system or service.\\n\\n\\n\\n---\\n\\n## Non-repudiation and Authentication \\n\\n### Non-repudiation \\n> Legal Concept: Can only be solved through legal and social processes.\\n* Describes the service that ensures entities are honest in their actions.\\n* Implies that both ends of a transmission cannot deny their involvement in this transmission.\\n\\n### Authentication \\n> Technical Concept: Can be solved through cryptography.\\n* A mechanism designed to verify the identity of an agent, human, or system before access is granted.\\n    * Example: Username and password authentication, PKI.\\n\\n---\\n\\n## IAAA (Access Management System) \\n* IAAA are essential functions in providing an access management system.\\n* Summarized as the authentication service as described by the MSR model.\\n* The current industry practice for implementing IAAA security is identity management.\\n    * Example: The use of logon IDs and passwords.\\n\\n### The IAAA Process\\n1. IDENTIFICATION (I am a user of the system) \\n    * A method for a user within a system to introduce oneself.\\n    * Identifiers must be unique so that a user can be accurately identified across the organization.\\n    * Each user should have a unique identifier, even if performing multiple roles.\\n2. AUTHENTICATION (I can prove I’m a user of the system) \\n    * Validates the identification provided by a user.\\n    * Most organizations require a second credential for the entity to be authenticated.\\n    * Three basic authentication factors: Something you know, something you have, and something you are (or can produce).\\n3. AUTHORIZATION (Here’s what I can do with the system) \\n    * The matching of an authenticated entity to a list of information assets and corresponding access levels.\\n    * Ways to handle authorization: Authenticated user, members of a group, or across multiple systems.\\n4. ACCOUNTABILITY \\n    * The act of being responsible for actions taken within the system.\\n    * The only way to ensure accountability is to identify the user and record their action.\\n\\n\\n\\n---\\n\\n## Assets, Threats, Vulnerabilities, Risks, and Controls \\n* The combination of vulnerabilities and threats contributes to risk.\\n\\n* Assets: \\n    * Anything valuable to the organization.\\n    * Can be tangible (hardware) or intangible (data, services, and people).\\n* Threats: \\n    * Potential events that may cause the loss of an information asset.\\n    * May be natural, deliberate, or accidental.\\n* Vulnerabilities: \\n    * Weaknesses within the information asset that are exploited by threats.\\n* Risks: \\n    * Expresses the chance of something happening (likelihood ).\\n* Controls: \\n    * Actions or mechanisms established to resolve information assurance issues.\\n    * Categories: Management, Operational, and Technical controls.\\n\\n### Common Threats \\n* Errors and Negligence: Programming bugs , typographical errors , misconfigured systems.\\n* Fraudulent and Theft Activities \\n* Loss of Infrastructure \\n* Malware \\n* Attackers: Elite hackers, script writers, and script kiddies.\\n* Hacker Types: White-hat, Black-hat, and Gray-hat.\\n\\n---\\n\\n## Information Life Cycle \\nCyclical stages: Create -> Process -> Use/Transmit/Store -> Retain -> Dispose \\n* Create: Information is generated internally.\\n* Process: Data is processed to meet organizational goals.\\n* Store: Results are saved for later use.\\n* Retain: Information is kept as part of legal requirements.\\n* Dispose: Information is destroyed if the organization has no use for it.\\n\\n\\n\\n---\\n\\n## Plan-Do-Check-Act Model (PDCA) \\n* Implementation of a continuous improvement process for an effective IAMS.\\n* ISO/IEC 27000 is the specification standard for this model.\\n\\n* Plan: Establish the IAMS; focuses on documenting policy, scope, and risk approach.\\n* Do: Implement, operate, and maintain the IAMS; put controls into practice.\\n* Check: Monitor and review the IAMS; assess performance and conduct audits.\\n* Act: Execute, maintain, and improve the IAMS; implement corrective actions.\\n\\n---\\n\\n## Boyd’s OODA Loop \\nDeveloped by U.S. Air Force Colonel John Boyd to describe strategic operations.\\n\\n1. Observe: Gather raw information about the situation.\\n2. Orient: The most important phase; inherently influences thoughts and can confuse adversaries.\\n3. Decide: Based on the orientation, a decision is made to act.\\n4. Act: The action is performed."
        },
        "1": {
            "header": "Approaches to Implementing Information Assurance",
            "body": "## Information Assurance Program\\n* In implementing an information assurance program, the approach taken also plays an important role. \\n* Sometimes a hybrid is the right decision in selecting a suitable approach. \\n* Top-down approach: used to match general corporate security requirements. \\n* Bottom-up approach: used at the same time to meet local security requirements within specific economies. \\n\\n\\n\\n---\\n\\n## Key Components of IA Approaches\\n* People\\n    * People are a challenging and crucial resource that need management. \\n    * By applying the right processes and technology, people add value to organizations. \\n    * Awareness, training, and education (AT&E) are key to making information assurance work. \\n* Process\\n    * Refers to the use of a formalized sequence of actions to achieve an aim. \\n* Technology\\n    * The hardware and software tools used to implement and enforce security. \\n\\n---\\n\\n## Level of Controls in an IA Program\\n\\n\\n\\n### Strategic Management\\n> Includes security processes such as conducting risk management exercises, security awareness programs, policy development, and compliance efforts with laws and regulations. \\n\\n### Tactical Management\\n> Examines business continuity, data classification, process management, personnel security, and risk management. \\n\\n### Operational Management\\n> Includes areas of communication security, security of an information system life cycle, and incident response."
        },
        "2": {
            "header": "Organizational Structure for Managing Information Assurance",
            "body": "## Organizational Structure for Managing Information Assurance\\n\\n> “Information Assurance is everyone’s responsibility” \\n\\nAn organizational structure is a system that outlines how certain activities are directed in order to achieve the goals of an organization.\\n\\n### Importance of IA Organizational Structure\\n* Continuous support and commitment from top management.\\n* Involvement of employees in the planning of local security systems.\\n* Executives’ better understanding of the organization.\\n* Secure management of information assets by the organization.\\n* Managers become more aware and familiar with specific security requirements.\\n* Secured physical and logical access to IT infrastructure.\\n\\n### IA Structure Types\\n\\n\\n\\n* HYBRID Structure:\\n    * IA program is managed under a centralized unit.\\n    * Roles, responsibilities, and authorities are spread throughout the organization.\\n    * A functional mix of both centralized and distributed structures.\\n\\n---\\n\\n## Roles and Responsibilities\\n\\n### Senior Management\\n* Establishes and enforces the organization's information assurance program.\\n* Endorses and approves policies and objectives supporting the vision and mission.\\n\\n### Executive Leadership\\n* Chief Executive Officer (CEO):\\n    * The highest-level senior official with overall responsibility for IA protections.\\n    * Ensures IA management processes are integrated with strategic and operational planning.\\n    * Ensures senior officials provide IA for systems under their control and that personnel are sufficiently trained.\\n* Chief Risk Officer (CRO):\\n    * Holds the risk executive functional role; provides an organization-wide approach to risk management."
        },
        "3": {
            "header": "Asset Management",
            "body": "## Asset Management\\n\\n> “A best-practice security risk assessment exercise begins with an identification of the assets…” \\n\\n### Asset Definition\\nAn asset is a resource with economic value that an individual, corporation, or country owns or controls with the expectation that it will provide a future benefit. \\n\\n### Types of Assets\\n* Tangible assets: Range from data files to physical assets, such as computer peripherals. \\n* Intangible assets: Include the image and reputation of the organization, general utilities, and skill sets of a workforce. \\n\\n---\\n\\n## ISO/IEC 27000 Series and Asset Management\\n* The ISO/IEC 27000 series is a set of standards for Information Security Management Systems (ISMS) that provides a framework for managing security risks and protecting information assets. \\n* Key standards include ISO/IEC 27001 (Requirements), ISO/IEC 27002 (Best Practices), and ISO/IEC 27005 (Risk Management). \\n* Asset management in this series focuses on identifying, classifying, and protecting information assets to mitigate security risks. \\n\\n### Asset Categories and Examples\\n| Category | Examples |\\n| :--- | :--- |\\n| Data/information | Databases, personnel records, proposals, contracts, manuals, statistics.  |\\n| Hardware | Computer/network equipment, tape, removable media.  |\\n| Intangible | Reputation, image, influence, intellectual property.  |\\n| People | Staff with expertise, skill, and knowledge on a subject.  |\\n| Service | Electricity, telecommunication service, lighting.  |\\n| Software | Application software, system software, system utility, development tool. |\\n\\n---\\n\\n## Importance and Key Components\\n\\n### Importance\\n* Proper asset management protects critical data and intellectual property. \\n* Ensures legal and regulatory compliance. \\n* Reduces breach risks and unauthorized access. \\n* Ensures business continuity and disaster recovery. \\n\\n### Key Components\\n* Asset Identification: Cataloging all information assets including data, software, hardware, networks, and personnel. \\n* Asset Classification: Assigning value and sensitivity levels to determine protection levels and access controls. \\n* Asset Ownership: Defining who is accountable and responsible for each asset. \\n* Asset Handling and Protection: Implementing security controls like Access Control (RBAC), encryption, and monitoring. \\n* Asset Disposal: Securely removing assets when no longer needed to prevent data leaks. \\n\\n---\\n\\n## Management Processes\\n\\n### Identification Methods\\n* Inventory tracking tools. \\n* Network discovery techniques. \\n* Manual audits and documentation. \\n\\n### Common Classifications\\n1. Public: No restrictions. \\n2. Internal: For internal use only. \\n3. Confidential: Restricted access. \\n4. Highly Sensitive: Strictly controlled access.\\n\\n### Roles in Asset Management\\n* Asset Owners: Accountable for managing and protecting assigned assets. \\n* Custodians: Responsible for maintaining and securing assets. \\n* Users: Must follow security policies and guidelines. \\n\\n### Disposal Best Practices\\n* Data wiping: Overwriting storage before disposal. \\n* Physical destruction: Shredding or degaussing. \\n* Secure recycling: Secure transfer or donation. \\n\\n### Risk Management Strategies\\n* Avoid: Eliminate the asset or risk. \\n* Mitigate: Apply security controls. \\n* Transfer: Through insurance or outsourcing. \\n* Accept: Based on business needs. \\n\\n### ISO/IEC 27001 Compliance\\nISO/IEC 27001 requires organizations to:\\n1. Define an asset management policy. \\n2. Maintain an inventory of assets. \\n3. Assign ownership and define security measures. \\n4. Conduct regular risk assessments and audits. "
        }
    },
    "items": {
        "0": {
            "text": "The C in CIA Triad stands for?",
            "answer": "Confidentiality",
            "difficulty": 1
        },
        "1": {
            "text": "This is often viewed as property of an information system or service.",
            "answer": "Availability",
            "difficulty": 2
        },
        "2": {
            "text": "Defense in depth relies heavily on this for architectural isolation.",
            "answer": "Segmentation",
            "difficulty": 2
        },
        "3": {
            "text": "The process of verifying a user's identity through technical means like cryptography.",
            "answer": "Authentication",
            "difficulty": 2
        },
        "4": {
            "text": "This component of CIA ensures that information has not been unauthorizedly modified.",
            "answer": "Integrity",
            "difficulty": 1
        },
        "5": {
            "text": "Examples of this CIA control include hashing, checksums, and CRC.",
            "answer": "Integrity controls",
            "difficulty": 2
        },
        "6": {
            "text": "This concept ensures both ends of a transmission cannot deny their involvement.",
            "answer": "Non-repudiation",
            "difficulty": 2
        },
        "7": {
            "text": "The act of a user introducing themselves to a system.",
            "answer": "Identification",
            "difficulty": 1
        },
        "8": {
            "text": "Matching an authenticated entity to access levels for information assets.",
            "answer": "Authorization",
            "difficulty": 2
        },
        "9": {
            "text": "The combination of vulnerabilities and threats contributes to this.",
            "answer": "Risk",
            "difficulty": 2
        },
        "10": {
            "text": "Anything valuable to the organization, whether tangible or intangible.",
            "answer": "Asset",
            "difficulty": 1
        },
        "11": {
            "text": "Weaknesses within an information asset that are exploited by threats.",
            "answer": "Vulnerabilities",
            "difficulty": 2
        },
        "12": {
            "text": "The probability of a particular risk occurring.",
            "answer": "Likelihood",
            "difficulty": 2
        },
        "13": {
            "text": "These controls relate to management, operational, and technical mechanisms.",
            "answer": "Categories of controls",
            "difficulty": 2
        },
        "14": {
            "text": "The first stage of the Information Life Cycle.",
            "answer": "Create",
            "difficulty": 1
        },
        "15": {
            "text": "The final stage of the Information Life Cycle where data is securely destroyed.",
            "answer": "Dispose",
            "difficulty": 1
        },
        "16": {
            "text": "The PDCA phase where policy, scope, and risk approach are documented.",
            "answer": "Plan",
            "difficulty": 2
        },
        "17": {
            "text": "The phase of the OODA loop that gather raw information about the situation.",
            "answer": "Observe",
            "difficulty": 2
        },
        "18": {
            "text": "The most important phase of the OODA loop because it influences thoughts.",
            "answer": "Orient",
            "difficulty": 3
        },
        "19": {
            "text": "The IA structure importance stating it is everyone's responsibility.",
            "answer": "Organizational Structure for Managing Information Assurance",
            "difficulty": 2
        },
        "20": {
            "text": "An IA structure that spreads roles and authorities throughout the organization under a centralized unit.",
            "answer": "Hybrid Structure",
            "difficulty": 2
        },
        "21": {
            "text": "The role that establishes and enforces the organization's IA program.",
            "answer": "Senior Management",
            "difficulty": 2
        },
        "22": {
            "text": "Highest-level official with overall responsibility for IA protections.",
            "answer": "Chief Executive Officer (CEO)",
            "difficulty": 1
        },
        "23": {
            "text": "Role that provides an organization-wide approach to risk management.",
            "answer": "Chief Risk Officer (CRO)",
            "difficulty": 2
        },
        "24": {
            "text": "Role that designates a senior information security officer and develops policies.",
            "answer": "Chief Information Officer (CIO)",
            "difficulty": 2
        },
        "25": {
            "text": "Primary liaison for the CIO who administers security program functions.",
            "answer": "Chief Information Security Officer (CISO)",
            "difficulty": 2
        },
        "26": {
            "text": "Official who accepts responsibility for unmitigated risks and can halt operations.",
            "answer": "Accrediting Official (AO)",
            "difficulty": 3
        },
        "27": {
            "text": "Conducts comprehensive assessments to see if controls are operating as intended.",
            "answer": "Information Assurance Control Assessor (IACA)",
            "difficulty": 2
        },
        "28": {
            "text": "Role that captures and refines IA requirements into IT products.",
            "answer": "Information Assurance Engineer (IAE)",
            "difficulty": 2
        },
        "29": {
            "text": "Role that serves as a liaison between the enterprise architect and IA engineer.",
            "answer": "Information Assurance Architect (IAA)",
            "difficulty": 3
        },
        "30": {
            "text": "Principal advisor on all matters involving the assurance of an information system.",
            "answer": "Information System Security Officer (ISSO)",
            "difficulty": 2
        },
        "31": {
            "text": "Official responsible for the full life cycle of a specific system from procurement to disposal.",
            "answer": "Information System Owner",
            "difficulty": 2
        },
        "32": {
            "text": "Responsible for the development and monitoring of shared/common controls.",
            "answer": "Common Control Provider (CCP)",
            "difficulty": 2
        },
        "33": {
            "text": "A resource with economic value owned with the expectation of future benefit.",
            "answer": "Asset",
            "difficulty": 1
        },
        "34": {
            "text": "Examples include reputation, image, and skill sets of a workforce.",
            "answer": "Intangible assets",
            "difficulty": 2
        },
        "35": {
            "text": "ISO standard specifically for ISMS Risk Management.",
            "answer": "ISO/IEC 27005",
            "difficulty": 3
        },
        "36": {
            "text": "The process of cataloging all hardware, software, and personnel assets.",
            "answer": "Asset Identification",
            "difficulty": 2
        },
        "37": {
            "text": "Assigning levels like 'Confidential' or 'Public' based on sensitivity.",
            "answer": "Asset Classification",
            "difficulty": 1
        },
        "38": {
            "text": "The person accountable for managing and protecting assigned assets.",
            "answer": "Asset Owner",
            "difficulty": 2
        },
        "39": {
            "text": "Best practice involving overwriting storage before disposal.",
            "answer": "Data wiping",
            "difficulty": 2
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
        },
        "2": {
            "text": "A bank discovers that a virus has modified several transaction records without authorization. Which pillar of the CIA triad has been violated?",
            "options": [
                "Confidentiality",
                "Integrity",
                "Availability",
                "Non-repudiation"
            ],
            "answer": "Integrity",
            "difficulty": 2
        },
        "3": {
            "text": "During a regional outage, an e-commerce site remains up and running because of its redundant server setup. This maintains which security property?",
            "options": [
                "Authentication",
                "Confidentiality",
                "Integrity",
                "Availability"
            ],
            "answer": "Availability",
            "difficulty": 2
        },
        "4": {
            "text": "An IT manager is creating a document that outlines the specific security policy and scope of the management system. According to the PDCA model, which phase is this?",
            "options": [
                "Plan",
                "Do",
                "Check",
                "Act"
            ],
            "answer": "Plan",
            "difficulty": 2
        },
        "5": {
            "text": "A military commander is gathering raw data about enemy movements to prepare for a response. According to Boyd's model, which phase is being performed?",
            "options": [
                "Observe",
                "Orient",
                "Decide",
                "Act"
            ],
            "answer": "Observe",
            "difficulty": 2
        },
        "6": {
            "text": "An organization uses a structure where IA roles are spread across different departments, but there is a central unit that coordinates the entire program. What is this structure?",
            "options": [
                "Centralized",
                "Distributed",
                "Hybrid",
                "Segmented"
            ],
            "answer": "Hybrid",
            "difficulty": 2
        },
        "7": {
            "text": "A high-level official is tasked with signing off on a new information system despite knowing there are some minor unmitigated risks. Who is this?",
            "options": [
                "CISO",
                "Accrediting Official (AO)",
                "IA Architect",
                "Common Control Provider"
            ],
            "answer": "Accrediting Official (AO)",
            "difficulty": 3
        },
        "8": {
            "text": "A company is disposing of old hard drives. To prevent data leaks, they use a machine to physically shred the platters. This is a best practice of:",
            "options": [
                "Asset Identification",
                "Asset Classification",
                "Asset Disposal",
                "Asset Ownership"
            ],
            "answer": "Asset Disposal",
            "difficulty": 2
        },
        "9": {
            "text": "A security team decides to buy cyber-insurance to cover potential losses from a breach rather than spending more on internal firewalls. What risk strategy is this?",
            "options": [
                "Avoid",
                "Mitigate",
                "Transfer",
                "Accept"
            ],
            "answer": "Transfer",
            "difficulty": 3
        }
    } 
}
  ''';
  }
}