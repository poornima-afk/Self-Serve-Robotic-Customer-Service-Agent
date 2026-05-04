# Self-Serve Robotic Customer Service Agent

A Salesforce-powered intelligent customer service solution built with Agentforce that provides automated financial services support including account management, transaction verification, EMI management, and document processing.

## 🌟 Overview

This project implements a comprehensive self-service customer support system using Salesforce Agentforce AI technology. The agent can handle various financial service operations autonomously, including account verification, balance inquiries, transaction disputes, EMI adjustments, and document data extraction.

## 🚀 Key Features

### 1. **Intelligent Customer Service Agent**
- AI-powered conversational interface using Agentforce
- Natural language understanding for customer queries
- Automated routing and case management
- Multi-channel support capability

### 2. **Financial Account Management**
- Account verification via phone number
- Balance and transaction history retrieval
- Real-time account status updates
- Multi-account handling per customer

### 3. **Transaction & Dispute Management**
- Disputed transaction identification and tracking
- Transaction verification workflows
- Automated dispute case creation
- Transaction history analysis

### 4. **EMI Management**
- Dynamic EMI tenure adjustment (extend/reduce)
- Automated EMI recalculation
- Loan modification processing
- Real-time EMI amount updates

### 5. **Document Intelligence**
- Image-based data extraction using Einstein Vision
- Automated document processing
- OCR capabilities for customer documents
- Support for various document types (IDs, statements, etc.)

### 6. **Security & Verification**
- Multi-factor authentication support
- Verification code generation and validation
- Person account verification workflows
- OAuth token management for secure integrations

## 📋 Prerequisites

- Salesforce Developer Edition or higher org
- Salesforce CLI installed
- Node.js (v18 or higher)
- Git

## 🛠️ Installation

### 1. Clone the Repository
```bash
git clone https://github.com/poornima-afk/Self-Serve-Robotic-Customer-Service-Agent.git
cd Self-Serve-Robotic-Customer-Service-Agent
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Authenticate with Salesforce
```bash
sf org login web --set-default-dev-hub --alias my-hub
```

### 4. Create a Scratch Org
```bash
sf org create scratch --set-default --definition-file config/project-scratch-def.json --alias service-agent-org --duration-days 30
```

### 5. Deploy Metadata
```bash
sf project deploy start --source-dir force-app
```

### 6. Assign Permission Sets (if applicable)
```bash
sf org assign permset --name <PermissionSetName>
```

### 7. Open the Scratch Org
```bash
sf org open
```

## 📁 Project Structure

```
Self-Serve-Robotic-Customer-Service-Agent/
├── force-app/main/default/
│   ├── aiAuthoringBundles/
│   │   └── Financial_Service_Agent/     # AI agent configuration
│   ├── bots/
│   │   └── Agentforce_Service_Agent/    # Bot metadata
│   ├── classes/
│   │   ├── EMIManagement.cls            # EMI calculation logic
│   │   ├── ExtractDataFromImage.cls     # Document processing
│   │   └── OAuthTokenUtil.cls           # OAuth utilities
│   ├── flows/
│   │   ├── Person_Account_Verification.flow-meta.xml
│   │   ├── Get_Financial_Account_by_Phone_Number.flow-meta.xml
│   │   ├── Get_Financial_Account_Balance_and_Transaction.flow-meta.xml
│   │   ├── Get_Disputed_Transactions.flow-meta.xml
│   │   ├── Verify_Verification_Code.flow-meta.xml
│   │   ├── ExtendTenure.flow-meta.xml
│   │   └── ReduceTenure.flow-meta.xml
│   ├── objects/                         # Custom object definitions
│   ├── permissionsets/                  # Permission configurations
│   └── staticresources/                 # Static assets
├── config/
│   └── project-scratch-def.json         # Scratch org definition
├── scripts/
│   ├── apex/                            # Apex scripts
│   └── soql/                            # SOQL queries
├── package.json
├── sfdx-project.json
└── README.md
```

## 🔧 Configuration

### Setting Up the Agent

1. **Navigate to Setup** → Digital Engagement → Agents
2. **Locate** "Financial Service Agent"
3. **Configure** the agent topics and actions
4. **Publish** the agent to make it available

### Configuring Flows

The project includes several pre-configured flows that power the agent's capabilities:

- **Person_Account_Verification**: Validates customer identity
- **Get_Financial_Account_by_Phone_Number**: Retrieves account details
- **Get_Financial_Account_Balance_and_Transaction**: Fetches balance and transaction history
- **Get_Disputed_Transactions**: Identifies disputed transactions
- **Verify_Verification_Code**: Validates authentication codes
- **ExtendTenure/ReduceTenure**: Manages EMI tenure modifications

### Einstein Vision Setup (for Document Processing)

1. Enable Einstein Vision in your org
2. Configure the `ExtractDataFromImage` class with your Einstein Vision credentials
3. Train models for specific document types if needed

## 💡 Usage Examples

### Customer Verification
```
Customer: "I want to check my account balance"
Agent: Initiates Person_Account_Verification flow
→ Validates identity
→ Retrieves Financial Account by Phone
→ Displays Balance and Recent Transactions
```

### EMI Modification
```
Customer: "I want to extend my loan tenure"
Agent: Validates loan details
→ Calculates new EMI using EMIManagement class
→ Executes ExtendTenure flow
→ Updates loan terms
→ Confirms new EMI amount
```

### Dispute Management
```
Customer: "I want to dispute a transaction"
Agent: Retrieves account transactions
→ Identifies disputed transactions
→ Creates case for investigation
→ Routes to appropriate team
```

## 🧪 Testing

### Run Apex Tests
```bash
sf apex run test --wait 10 --result-format human --code-coverage --test-level RunLocalTests
```

### Run Jest Tests (LWC)
```bash
npm test
```

### Manual Testing
1. Open the agent interface in your Salesforce org
2. Test various conversation flows
3. Verify data accuracy and flow execution

## 📊 Key Components

### Apex Classes

- **EMIManagement**: Handles EMI calculations and loan modifications
  - `calculateEMI()`: Computes monthly EMI based on principal, rate, and tenure
  - `extendTenure()`: Extends loan tenure and recalculates EMI
  - `reduceTenure()`: Reduces tenure and adjusts EMI

- **ExtractDataFromImage**: Processes documents using Einstein Vision
  - `extractData()`: Extracts text and structured data from images
  - Supports multiple document formats

- **OAuthTokenUtil**: Manages OAuth authentication
  - `getAccessToken()`: Retrieves OAuth tokens for integrations

### Flows

All flows are screen flows or autolaunched flows that integrate with the Agentforce bot to provide seamless customer experiences.

## 🔐 Security Considerations

- All customer data access is logged and auditable
- Permission sets control feature access
- OAuth tokens are securely managed
- Verification codes expire after use
- PII data is handled according to Salesforce security standards

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is part of a Salesforce implementation. Refer to your Salesforce license agreement for terms and conditions.

## 🐛 Troubleshooting

### Common Issues

**Issue**: Agent not responding
- **Solution**: Verify the agent is published and active in Setup

**Issue**: Flow errors during execution
- **Solution**: Check flow debug logs and verify all required fields are populated

**Issue**: EMI calculation errors
- **Solution**: Ensure principal amount, interest rate, and tenure are valid numbers

**Issue**: Image extraction not working
- **Solution**: Verify Einstein Vision is enabled and properly configured

## 📞 Support

For issues and questions:
- Create an issue in the GitHub repository
- Review Salesforce Agentforce documentation
- Check Salesforce Trailhead for learning resources

## 🔄 Version History

- **v1.0.0** (Latest): Initial release with core financial service agent capabilities
  - Account verification and management
  - Transaction and dispute handling
  - EMI management
  - Document processing with Einstein Vision

## 🎯 Future Enhancements

- [ ] Multi-language support
- [ ] Advanced analytics dashboard
- [ ] Integration with external banking systems
- [ ] Mobile app integration
- [ ] Voice-enabled interactions
- [ ] Predictive customer service using AI

## 📚 Additional Resources

- [Salesforce Agentforce Documentation](https://help.salesforce.com/s/articleView?id=sf.bots_service_intro.htm)
- [Einstein AI Documentation](https://help.salesforce.com/s/articleView?id=sf.einstein_platform.htm)
- [Salesforce Flow Documentation](https://help.salesforce.com/s/articleView?id=sf.flow.htm)

---