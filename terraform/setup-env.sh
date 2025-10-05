#!/bin/bash

# Oracle Cloud Environment Variables Setup Script
# This script helps set the required environment variables for Terraform
# Run: source ./setup-env.sh

echo "🔧 Setting up Oracle Cloud environment variables for Terraform..."
echo

# Check if required values are provided
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "❌ Usage: source ./setup-env.sh <tenancy_ocid> <user_ocid> <compartment_ocid>"
    echo
    echo "📋 Get these values from Oracle Cloud Console:"
    echo "   • Tenancy OCID: Profile menu → Tenancy"
    echo "   • User OCID: Profile menu → My Profile"
    echo "   • Compartment OCID: Identity & Security → Compartments"
    echo
    echo "🔑 Your fingerprint: b2:bc:37:6a:c3:fc:e1:87:76:87:24:c9:14:29:da:6f"
    echo
    return 1
fi

# Set the environment variables
export TF_VAR_tenancy_ocid="$1"
export TF_VAR_user_ocid="$2"
export TF_VAR_compartment_ocid="$3"
export TF_VAR_fingerprint="b2:bc:37:6a:c3:fc:e1:87:76:87:24:c9:14:29:da:6f"

echo "✅ Environment variables set!"
echo "   • TF_VAR_tenancy_ocid: ${TF_VAR_tenancy_ocid:0:20}..."
echo "   • TF_VAR_user_ocid: ${TF_VAR_user_ocid:0:20}..."
echo "   • TF_VAR_compartment_ocid: ${TF_VAR_compartment_ocid:0:20}..."
echo "   • TF_VAR_fingerprint: $TF_VAR_fingerprint"
echo

echo "🚀 You can now run:"
echo "   terraform init"
echo "   terraform plan"
echo "   terraform apply"
echo

# Save to a local file for reuse
cat > .env.local << EOF
# Oracle Cloud Environment Variables (DO NOT COMMIT)
export TF_VAR_tenancy_ocid="$1"
export TF_VAR_user_ocid="$2"
export TF_VAR_compartment_ocid="$3"
export TF_VAR_fingerprint="b2:bc:37:6a:c3:fc:e1:87:76:87:24:c9:14:29:da:6f"
EOF

echo "💾 Variables also saved to .env.local (git-ignored)"
echo "   Next time you can run: source .env.local"