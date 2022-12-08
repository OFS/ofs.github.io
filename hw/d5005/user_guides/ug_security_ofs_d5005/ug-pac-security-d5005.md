# **Security User Guide: Intel® Open FPGA Stack for Intel® Stratix 10 FPGA**

You may not use or facilitate the use of this document in connection with any infringement or other legal analysis concerning Intel® products described herein. 
No license (express or implied, by estoppel or otherwise) to any intellectual property rights is granted by this document.

All information provided here is subject to change without notice. Contact your Intel® representative to obtain the latest Intel product specifications and roadmaps.

The products described may contain design defects or errors known as errata which may cause the product to deviate from published specifications. Current characterized errata are available on request.
Intel, the Intel logo, Agilex, Altera, Arria, Cyclone, Enpirion, eASIC, easicopy, MAX, Nios, Quartus, Stratix words and logos are trademarks of Intel Corporation or its subsidiaries in the U.S. and/or other countries. Intel warrants performance of its FPGA and semiconductor products to current specifications in accordance with Intel's standard warranty, but reserves the right to make changes to any products and services at any time without notice. Intel assumes no responsibility or liability arising out of the application or use of any information, product, or service described herein except as expressly agreed to in writing by Intel. Intel customers are advised to obtain the latest version of device specifications before relying on any published information and before placing orders for products or services.

*Other names and brands may be claimed as the property of others.
Copyright © 2022, Intel Corporation. All rights reserved.


### Table of Contents

1. [Overview](#overview)

    1. [About This Document](#about-this-document)
    
    2. [Prerequisites](#prerequisites)
    
    3. [Related Documentation](#related-documentation)
    
    4. [Glossary](#glossary)

2. [Intel FPGA PAC Security Features](#intel-fpga-pac-security-features)

    1. [Secure Image Updates](#secure-image-updates)

    2. [Anti-Rollback Capability](#anti-rollback-capability)

    3. [Key Management](#key-management)

    4. [Authentication](#authentication)

3. [Intel FPGA PAC Security Flow](#intel-fpga-pac-security-flow)

    1. [Installing PACSign](#installing-pacsign)

    2. [PACSign Tool](#pacsign-tool)

    3. [Creating Unsigned Images](#creating-unsigned-images)

    4. [Using an HSM Manager](#using-an-hsm-manager)

    5. [Creating Keys](#creating-keys)

        1. [OpenSSL Key Creation](#openssl-key-creation)

        2. [HSM Key Creation](#hsm-key-creation)

    6. [Root Entry Hash Bitstream Creation](#root-entry-hash-bitstream-creation)

    7. [Signing Images](#signing-images)

    8. [Creating a CSK ID Cancellation Bitstream](#creating-a-csk-id-cancellation-bitstream)

    9. [PACSign PKCS11 Manager \*.json Reference](#pacsign-pkcs11-manager-.json-reference)

    10. [Creating a Custom HSM Manager](#creating-a-custom-hsm-manager)

        1. [HSM_MANAGER.get_public_key(public_key)](#hsm_manager.get_public_keypublic_key)

        2. [HSM_MANAGER.sign(data, key)](#hsm_manager.signdata-key)

        3. [Signing Operation Flow](#signing-operation-flow)

    11. [PACSign Man Page](#pacsign-man-page)

4. [Using fpgasupdate](#using-fpgasupdate)

    1. [Troubleshooting](#troubleshooting)
    
5. [Intel® Open FPGA Stack](#ofs)

    1. [Accessing Intel FPGA PAC Version and Authentication Information](#pacversion)
        
        1. [Using fpgainfo security Command](#fpgainfosecurity)
        
        1. [Reading sysfs Files for Identifying Information](#sysfs)
        
        1. [Using bitstreaminfo Tool](#bitstreaminfo)

6. [Revision History](#revision-history)

## 1. Overview 
<a name="overview"></a>

### 1.1  About This Document
<a name="about-this-document"></a>

Reference this user guide to understand and enable the security features for Intel® Open FPGA Stack such as Root of Trust (RoT) and FIM, BMC, PR signing.

### 1.2 Prerequisites
<a name="prerequisites"></a>

You must ensure that the host and Intel FPGA PAC are using the current version of OPAE tools. Please refer to the latest version of the Intel® OFS Getting Started User Guide.

### 1.3 Related Documentation
<a name="related-documentation"></a>
Refer to the following documentation while using this guide:

#### Table 1. Related Documentation

  **Document**                   |  **Description**
---------------------------------|----------------------------------
[Intel® OFS Getting Started User Guide](https://github.com/otcshare/intel-ofs-docs/blob/main/d5005/user_guides/ug_qs_ofs_d5005/ug_qs_ofs_d5005.md)     | How to install and update OPAE and the FPGA Interface Manager
[Intel® OFS Board Management Controller User Guide](https://github.com/otcshare/intel-ofs-docs/blob/main/d5005/user_guides/ug_bmc_ofs_d5005/IOFS_BMC_User_Guide.md)  | Features of the board management controller (BMC) not related to security, such as BMC Firmware and sensor monitoring through PLDM commands.
### 1.4 Glossary
<a name="glossary"></a>

#### Table 2. Glossary

  **Acronym/Term**  |  **Expansion**      | **Description**
--------------------|---------------------|-------------------------
AFU                 | Accelerator Functional Unit         | Hardware Accelerator implemented in FPGA logic which offloads a computational operation for an application from the CPU to improve performance.
CSK                 | Code Signing Key   | A key used to validate and authenticity integrity of a block of code. Authenticity of this key is established through signing  with a root key.
ECDSA              | Elliptical Curve Digital Signature Algorithm    |  An algorithm based on elliptic curve cryptography to create signatures that can be used to evaluate the authenticity of an object.
FIM                | FPGA Interface Manager  | The FPGA shell containing the FPGA Interface Unit (FIU) and external interfaces for memory, networking, etc. The FIM may also be referred to as BBS (Blue-Bits, Blue Bit Stream) in the Acceleration Stack installation directory tree and in source code comments. The Accelerator Function (AF) interfaces with the FIM at run time.
HSM                | Hardware Security Module  | A secure hardware device to hold, protect, and allow access to cryptographic objects; performs cryptographic operations in a trusted environment.
NIST p Curve       | National Institute of Standards and Technology prime Curve | P256 is used throughout this document. Without any other associations added, P256 means NIST P256 curves, where p is a 256-bit prime.
OPAE               | Open Programmable Acceleration Engine   | The OPAE is a software framework for managing and accessing AFs.
OTSU               | One-time secure update    | Updates the Intel MAX® 10 BMC with new image files to enable the RoT features.
PKCS               | Public Key Cryptography Standard         | PKCS#11 is used throughout this document. PKCS#11 is a commonly used interface for commercial hardware security modules (HSMs).
PR                 | Partial Reconfiguration             | The ability to dynamically reconfigure a portion of an FPGA while the remaining FPGA design continues to function. In the context of Intel FPGA PAC, a PR bitstream refers to an Intel FPGA PAC D5005 AFU. Intel FPGA PAC N3000 does not support partial reconfiguration bitstreams. Refer to to [Partial Reconfiguration](https://www.intel.com/content/www/us/en/programmable/products/design-software/fpga-design/quartus-prime/features/partial-reconfiguration.html) support page.
Root Key           | \-                  | A key designated as the primary, constant value for authentication. Typically only used to sign other keys, forming the root of all key chains.
RoT                | Root of Trust       | A source that can be trusted, such as the BMC in the Intel FPGA PAC.
RSU                | Remote System Update       |Ability to update firmware and FPGA bitstreams over PCIe.
SR                 | Static Region       |Portion of the FPGA design that does not change.

## 2. Intel FPGA PAC Security Features
<a name="intel-fpga-pac-security-features"></a>

The Intel MAX 10 board management controller (BMC) acts as a Root of
Trust (RoT) and enables the secure update features of an Intel platform using Intel OFS. The RoT includes features that may help prevent the following:

- Loading or execution of unauthorized code or designs.

- Disruptive operations attempted by unprivileged software, privileged software, or the host BMC.

- Unintended execution of older code or designs with known bugs or vulnerabilities by enabling the BMC to revoke authorization.

The Intel OFS BMC also enforces several other security policies relating to access through various interfaces, as well as protecting the on-board flash through write rate limitation.

> *Note:* The Intel OFS BMC has been validated on the Intel FPGA PAC D5005. The terms BMC or BMC RoT refer to the Intel OFS\'s Intel MAX 10 BMC (as opposed to another BMC, such as the host or motherboard BMC) unless otherwise noted.

The BMC verifies:

- Intel MAX 10 BMC Nios® firmware and Intel MAX 10 FPGA images

- FIM images

- AFU (partial reconfiguration region) images

When deploying your custom Intel OFS platform you must create code signing keys and generate the program root entry hashes for both the FIM and BMC onto your board.  The BMC uses the root entry hashes to authenticate whether the images being remotely programmed to the platform can be trusted.
If you are providing a workload or AFU that is programmed to the board through fpgasupdate, you can optionally create an AFU root entry hash to allow authentication of the AFU image.
After you program your root entry hashes on your platform and deploy your card in the field, the operation cannot be reversed and FIM, BMC and AFU images without correct signatures will be refused by the platform.  
A correct signature is one created by PACSign with a code signing key (CSK) that is both signed by the root key and not yet canceled.

### 2.1 Secure Image Updates
<a name="secure-image-updates"></a>

The Intel MAX 10 BMC RoT requires that all BMC firmware, BMC RTL, and FIM images are authenticated using ECDSA before loading and executing on the card. The Intel MAX 10 BMC RoT may optionally require that AFU images are authenticated before loading and executing as well. The RoT achieves this by storing the root entry hash bitstream for the corresponding image in a write-once location and subsequently verifying the signature of all images against these hashes. For your custom Intel OFS design, you must provide the root entry hash bitstreams for BMC firmware, BMC RTL, FIM images, and optionally AFU images. Until you program the root entry hash bitstreams, your platform will not authenticate images prior to loading and executing the image.

The table below compares the origin of the root key for a PAC provided by Intel versus a custom platform of your own design.

#### Table 3. Keys and Authentication

 **Root Key**           | **D5005** |**Custom Platform** | **Used to Authenticate**
------------------------|------------|---------------------|-------------------------
Intel MAX 10 BMC root key      | Intel      | Board Developer    | Intel MAX 10 Images and Firmware
Partial reconfiguration (PR) AFU root key     | Customer   | Customer    | AFUs
FIM | Intel     | Board Developer  | Used to authenticate the FIM
Flat Image (FIM + AFU) |Customer    |  Customer     | Used to authenticate FIM & AFU    

When you are in the development or validation phase and have not programmed your root entry hash bitstream, you create images that contain the appropriate headers but are not signed using keys. This process is called creating an unsigned image. A platform that has not had the root entry hash bitstream programmed runs any unsigned image. This capability allows you to test and validate the functionality of your AFU image prior to fully signing the images for deployment into a production environment. Please refer to the *Creating Unsigned Images* section for more information.

You program your root entry hash bitstream to enable image authentication. This process establishes you as the owner of the platform. The platform then requires you to create signatures based on this root entry for each image you intend to load on the Intel FPGA PAC. Intel strongly recommends that you program the root entry hash bitstreams for your custom platform used in production environments. You must follow the following flow to enable user image authentication on your Intel FPGA PAC.

#### Figure 1. Secure User Image Flow

![Figure 1. Secure User Image Flow](figures/Figure1.PNG)

The chapters within this user guide cover the steps in this flow:

1. **Create your keys:** Create your keys using a Hardware Security Module (HSM) or OpenSSL. You need at least two keys, one which you designate as a root key and another you designate as a code signing key (CSK). These keys are asymmetric keys, meaning they consist of an underlying pair of keys. The first is called a private key and the second is a public key that is derived from the private key. A private key is used to create signatures over objects that can be verified with the corresponding public key. The private key must be kept confidential, as anyone in possession of the private key can create a signature; conversely, if you maintain the confidentiality of the private key, then signatures can be trusted to originate only from you. The public key cannot create signatures or be used to derive the original private key. Therefore, it is not required nor important to protect the confidentiality of the public key; the public key is considered public information.

2. **Create your root entry hash bitstream:** Use the PACSign tool to create a bitstream that contains the root entry hash. You create a root entry hash bitstream from your root public key. This hash is a representation of your root public key and can only be created with an exact copy of the root public key. The root entry hash bitstream is then programmed on your platform. Your customer Intel OFS platform then uses this hash to verify the integrity of the root public key, which is included with all images transmitted to the platform. After the integrity of the root public key is confirmed, it can be used in the signature verification process.

3. **Program your root entry hash bitstream into your Intel OFS platform**. You must use the *fpgasupdate* command to program a bitstream containing your root entry hash into the flash on the board. Until you program the root entry hash bitstream, the platform loads and executes any signed or unsigned image. Intel strongly recommends that you create and program a root entry hash bitstream for platforms deployed in production environments. Please refer to the Using *fpgasupdate* chapter for more information.

4. **Sign your image.** Using PACSign you can sign your image with the root public key and code signing key. Please refer to the Using *PACSign* chapter for more information.

5. **Program your image onto the your Intel OFS-enabled platform.** Use the *fpgasupdate* command to program your image into flash. The platform verifies the image to ensure only an authorized bitstream is loaded. The root public key, code signing public key, signature of the code signing public key, and signature of the code or design are all attached to the image transmitted to your Intel OFS-enabled platform. The card first verifies the integrity of the root public key, then verifies the signature of the code signing public key using the root public key, and finally proceeds to verify the signature of the code or design using the code signing public key. The code or design is only accepted if all three of these steps are completed successfully.

#### Related Information

[Creating Unsigned Images](#creating-unsigned-images)

### 2.2 Anti-Rollback Capability 
<a name="anti-rollback-capability"></a>

The Intel MAX 10 BMC RoT provides anti-rollback capability through the code signing key ID cancellation feature. A CSK is assigned an ID, a number between 0-31, during the signing process. CSK ID cancellation information is stored in 32-bit fields in write- once locations in flash. When a code signing key ID is canceled, the Intel MAX 10 BMC RoT rejects all signatures created with a CSK that is assigned that ID. If a CSK ID that is used in an old update is canceled after applying a new update with a different CSK ID, the Intel MAX 10 BMC RoT rejects the signature of the old update, preventing a rollback to the old update.

> *Note:* If you cancel a key and do not update your image with a different CSK ID, the old image continues to be operational unless the user updates it with the new image signed with a different CSK ID.

### 2.3 Key Management
<a name="key-management"></a>

The Intel MAX 10 BMC RoT uses ECDSA with a key length of 256 bits to authenticate:

- Intel MAX 10 BMC Nios firmware and Intel MAX 10 FPGA images

- FIM images

- AFU (partial reconfiguration) images

- Flat Image (FIM + AFU)


The Intel MAX 10 BMC RoT supports separate key chains for each image, and each key chain must consist of a root key and a CSK.

The Intel MAX 10 BMC RoT does not support a signature of any image with a root key. You must use a key designated as a 

CSK to sign your image. Steps you are responsible for when creating keys, root entry hashes and programming your image on a security enabled Intel OFS platform are:

- You must manage assigning CSK IDs to CSKs and consistently using the same ID for a given CSK. Neither a platform nor the PACSign tool associate a particular key's value with its ID. It is possible to assign a given CSK multiple IDs, or multiple CSKs to a given ID. This may result in unintended consequences when attempting to cancel a CSK. Intel recommends exclusive ID assignments for each CSK.

- You  are responsible for creating the appropriate key cancellation bitstreams. You must use the same ID number for key cancellation as the one you assigned to the CSK at key creation. Key cancellation bitstreams must be signed with the applicable root key. This helps avoid denial of service through an unintended cancellation of all key values.

> *Note:* The Intel FPGA PAC D5005 has the capability to cancel up to 32 AFU CSK IDs. Only CSK IDs 0-31 are valid for an Intel FPGA PAC D5005 AFU CSK.

- You are responsible for generating and managing your image root key and CSKs. You generate the image root entry hash bitstream using your root key.

- You are also responsible for programming this root entry hash bitstream on the platform. If your Intel OFS platform does not have a programmed image root entry hash bitstream stored, it executes any signed or unsigned image.

> *Note:* Intel strongly recommends programming an image root entry hash bitstream. You must protect the confidentiality of the root private key throughout the life of the platform.

The Intel MAX 10 BMC RoT stores a root entry hash bitstreams in the on-board flash for:

1. BMC Nios firmware and Intel MAX 10 FPGA images

2. FIM images


The BMC is architected so that all root entry hashes cannot be revoked, changed, or erased once programmed.

If you have a board that has not been updated with the Intel MAX 10 RoT, you must use the one-time secure update to program the root entry hash bitstreams for the BMC firmware, RTL and Intel FIM images on your Intel OFS platform. For mor details about the OTSU update consult [the Intel Acceleration Stack Quick Start Guide: Intel FPGA Programmable Acceleration Card D5005](https://www.intel.com/content/www/us/en/programmable/documentation/edj1542148561811.html)

#### Related Information

[Using fpgainfo security Command](#fpgainfosecurity)

### 2.4 Authentication
<a name="authentication"></a>

To enable authentication:

1. Use the PACSign tool to create a root entry hash bitstream.

2. Use the *fpgasupdate* tool to program the bitstream onto the Intel FPGA PAC.

> \$ sudo fpgasupdate \[\--log-level=*\<level\>*\] *file \[bdf\]*

3. After the root entry hash bitstream is programmed, your platform must be power cycled. Use the *rsu* tool to power cycle the platform

> \$ sudo rsu bmcimg *[bdf\]*

On subsequent boots of your platform, the Intel MAX 10 BMC RoT programs the Intel Stratix 10 FPGA with the Intel FIM, reads the root entry hash from the on-board flash, and transmits the hash to the Intel Stratix 10 Secure Device Manager (SDM). The SDM then performs authentication of the image signature before loading the image.

All key operations are done using PACSign. PACSign is a standalone tool that is not required to be run on a machine with your platform installed. Key creation, signing, and cancellation bitstream creation are not runtime operations and can be performed at any time. The signing process prepends the signature to the image file. The BMC RoT does not need access to the HSM at any point to verify a signature.

The signing process requires a root key and a Code Signing Key (CSK). PACSign first signs the CSK with the root key, and then signs the image with the CSK. The signature process prepends two “blocks” of data to the image file.


## 3. Intel FPGA PAC Security Flow
<a name="intel-fpga-pac-security-flow"></a>
The following steps describe the flow to enable your custom Intel OFS design security. See the corresponding sections in this chapter for detailed instructions on each step.

1. **Install PACSign.**

2. If you are in development, you may optionally create an unsigned image to test and validate the functionality of your image prior to fully signing the image for deployment into a production environment. Please refer to the Creating Unsigned Images section for more information.

3. **Create your root key and CSK(s). You can use OpenSSL or an HSM for this action.**

#### Figure 2. Key Creation Using OpenSSL
![Figure 2 Key Creation Using OpenSSl](figures/Figure2.PNG)

#### Figure 3. Key Creation Using HSM pkcs11_tool
![Figure 3 Key Creation Using HSM PCCS11 tool](figures/Figure3.PNG)

4. **Create your root entry hash bitstream.**

#### Figure 4. Creating Root Entry Hash Bitstream with OpenSSL
![Figure 4 Creating Root Entry Hash Bitstream with OpenSSL](figures/Figure4.PNG)

#### Figure 5. Creating Root Entry Hash Bitstream with HSM pkcs11_manager
![Figure 5 Creation Root Entry Hash Bistream with HSM pkcs11_manager](figures/Figure5.PNG)

5. **Program your root entry hash bitstream onto your platform.** You must power cycle the platform after you have programmed the root entry hash bitstream.

6. **Sign your image.**

#### Figure 6. Signing your image with OpenSSL
![Figure 6 Signing your image with OpenSSL](figures/Figure6.PNG)

#### Figure 7. Signing your image with pkcs11_manager
![Figure 7 Signing your image with pkcs11_manager](figures/Figure7.PNG)

7. **Program your image into the platform.** For directions on how to program your image, refer to the *Using fpgasupdate* chapter.

#### Related Information

- [Creating Unsigned Images](#creating-unsigned-images)

- [Using fpgasupdate](#using-fpgasupdate)

### 3.1 Installing PACSign
<a name="installing-pacsign"></a>

PACSign is a standalone tool that interfaces with your HSM to manage root entry hash bitstream creation, image signing, and cancellation bitstream creation. PACSign is implemented in Python and requires Python 3.7. Using PACSign with the PKCS11 interface requires the python-pkcs11 package. PACSign does not need your Intel OFS-enabled platform installed in the system to run. Systems where signed images are being deployed to your platform do not need PACSign installed nor access to the HSM.


1. Follow the steps to install the OPAE Software Development kit explain in Intel® OFS Getting Started User Guide (https://github.com/otcshare/intel-ofs-docs/blob/main/d5005/user_guides/ug_qs_ofs_d5005/ug_qs_ofs_d5005.md) chapter 6


### 3.2 PACSign Tool
<a name="pacsign-tool"></a>

The PACSign utility is installed on your path.

- Use PACSign by simply calling it directly with the command *PACSign*

- Calling *PACSign* with the -h option shows a help message describing the tool usage.

- Typing *PACsign* *\<image_type\>* -h shows options available for that image type.

    >[PACSign_Demo]$ PACSign -h
    >
    > pacsign [-h] {SR,FIM,BBS,BMC,BMC_FW,PR,AFU,GBS,print} ...

    >Sign PAC bitstreams
    >optional arguments:
    >
    >-h, --help show this help message and exit
    >
    >Commands:
    >
    >Image types
    >
    >{SR,FIM,BBS,BMC,BMC_FW,PR,AFU,GBS,print}
    >
    >Allowable image types
    >
    >SR (FIM, BBS) Static FPGA image
    >
    >BMC (BMC_FW) BMC image
    >
    >PR (AFU, GBS) Reconfigurable FPGA image
    >
    >print               Print header information
    >
    >
    >[PACSign_Demo]$ PACSign AFU -h
    >
    >usage: PACSign PR [-h] -t {UPDATE,CANCEL,RK_256,RK_384} -H {openssl_manager,pkcs11_manager} [-C HSM_CONFIG] 
    >[-r ROOT_KEY] [-k CODE_SIGNING_KEY] [-d CSK_ID]
    >[-R ROOT_BITSTREAM] [-i INPUT_FILE] [-o OUTPUT_FILE]
    >[--print] [-y] [-v]
    >
    >optional arguments:
    >
    >-h, --help            show this help message and exit
    >  
    >-t                    {UPDATE,CANCEL,RK_256,RK_384}, --cert_type {UPDATE,CANCEL,RK_256,RK_384}
    >                    Type of certificate to generate
    >
    >-H                    {openssl_manager,pkcs11_manager}, --HSM_manager {openssl_manager,pkcs11_manager}
    >                    Module name for key / signing manager
    >
    > -C             HSM_CONFIG, --HSM_config HSM_CONFIG
    >                    Config file name for key / signing manager (optional)
    >
    >-r ROOT_KEY, --root_key ROOT_KEY
    >                    Identifier for the root key. Provided as-is to the key
    >                    manager
    >
    >-k CODE_SIGNING_KEY, --code_signing_key CODE_SIGNING_KEY
    >                    Identifier for the CSK. Provided as-is to the key
    >                    manager
    >
    > -d CSK_ID, --csk_id CSK_ID
    >                    CSK number. Only required for cancellation certificate

    >  -R ROOT_BITSTREAM, --root_bitstream ROOT_BITSTREAM
    >                    Root entry hash programming bitstream. Used to verify
    >                    update & cancel bitstreams.

    >  -i INPUT_FILE, --input_file INPUT_FILE
    >                        File name for the image to be acted upon
    >
    >  -o OUTPUT_FILE, --output_file OUTPUT_FILE
    >                    File name in which the result is to be stored

    >  --print               Print human-readable header information
    >
    >  -y, --yes             Answer all questions with "yes"
    >
    >  -v, --verbose         Increase verbosity. Can be specified multiple times


### 3.3  Creating Unsigned Images
<a name="creating-unsigned-images"></a>

The BMC secure firmware does not accept BMC, FIM, AFU, Flat image(FIM_AFU) without the prepended authentication blocks generated by PACSign, even if an image root entry hash bitstream has not been programmed. If you want to operate your Intel OFS platform without a root entry hash bitstream programmed, such as in a development environment, you must still use PACSign to prepend the authentication blocks but you may do so with an empty signature chain. An image with prepended authentication blocks containing an empty signature chain is called an unsigned image. PACSign supports the creation of an unsigned image by using the UPDATE operation without specifying keys. Intel recommends using signed images in production deployments. To create the unsigned bitstream your can use OpenSSL or HSM.

#### 1. Create unsigned bitstream

##### 1.1. Create unsigned bitstream using OpenSSL

    - AFU Image Unsigned

    >[PACSign_Demo]$ PACSign PR -t UPDATE -H openssl_manager -i hello_afu.gbs -o hello_afu_unsigned_ssl.gbs

    - BMC Image Unsigned:
    
    >$PACSign BMC -t UPDATE -H openssl_manager -i raw_unsigned_BMC.bin -o unsigned_BMC.bin
    
    - FIM Image Unsigned
    
    >$PACSign FIM -t UPDATE -H openssl_manager -i raw_unsigned_FIM.bin -o unsigned_FIM.bin
    
    - Flat (FIM + AFU) Image Unsigned
    
    >$PACSign FIM -t UPDATE -H openssl_manager -i raw_unsigned_flat.bin -o unsigned_flat.bin
    
##### 1.2. Create unsigned bitstream using HSM

    >[PACSign_Demo]$ PACSign PR -t UPDATE -H pkcs11_manager -C softhsm.json -i raw_unsigned_FIM.bin -o unsigned_FIM.bin

    The output prompts you to enter Y or N to continue generating an unsigned bitstream.
    >No root key specified. Generate unsigned bitstream? Y = yes, N = no: Y No CSK specified. Generate unsigned bitstream? Y = yes, N = no: Y

#### 2. Program the unsigned bitstream.

    >[PACSign_Demo]$ sudo fpgasupdate unsigned_FIM.bin b:d.f

#### 3. Perform RSU 

    >[PACSign_Demo]$ sudo rsu bmcimg b:d.f


### 3.4 Using an HSM Manager
<a name="using-an-hsm-manager"></a>

The PACSign tool does not implement any cryptographic functions. PACSign must interact with a cryptographic service, and it does this through modules called Hardware Security Module (HSM) managers. PACSign provides the following managers:

- openssl_manager: interfaces with OpenSSL

- pkcs11_manager: interfaces with any HSM implementing PKCS\#11

Use the -H option with the PACSign command to select an HSM manager.
The following sections provide examples for the PACSign OpenSSL manager using OpenSSL v1.1.1d, and the PACSign PKCS \#11 manager using SoftHSM v2.5.0. Examples of key creation and management with both OpenSSL and SoftHSM (through the utilities softhsm2-util and pkcs11-tool) are also provided. To create your own custom HSM manager, refer to the *Custom HSM Manager Creation* topic more information.

#### Related Information

[Creating a Custom HSM Manager](#creating-a-custom-hsm-manager)

### 3.5 Creating Keys
<a name="creating-keys"></a>
Create your root and code signing keys using your desired key management utility (HSM or OpenSSL). Assign your key CSK IDs during key creation. Intel recommends that you consistently use the same ID for a given key across all image signings.

#### 3.5.1 OpenSSL Key Creation
<a name="openssl-key-creation"></a>
When using OpenSSL, create a private key and then create the corresponding public key. The PACSign OpenSSL manager requires specific tags in the key file names using a format: *key\_\<image_type\>\_\<key_type\>\_\<key_visibility\>\_key.pem*.

#### Table 4. PACSign OpenSSL Manager Key File 

#### Name Requirements

**Filename Tag** | **Options**    | **Description**
-----------------|----------------|-------------------------
image_type       | -   fim <br> -bmc        | Identifies image type, BMC or FIM for which the key is intended. <br> -   For Intel FPGA PAC D5005, use; key_pr_<key_type>_<key_section>_key.
key_type       | -   root <br> -   csk\<x\>     | Identifies key type. \<x\> specifies an ID that you use for cancellation. <br>  -   Example:<br> -   key_pr_csk12_private_key.pem
key_visibility   | -   public <br>  -   private    | Identifies the key visibility

The following examples explain how to creates a root private key, root public key, and two code signing keys using OpenSSL for FIM, and BMC.


##### 1. FIM keys creation:

###### FIM private key:

 >[PACSign_Demo]$ openssl ecparam -name secp256r1 -genkey -noout -out key_fim_root_private_key.pem

 Output:
 
 > using curve name prime256v1 instead of secp256r1

###### FIM public key:

 >[PACSign_Demo]$ openssl ec -in key_fim_root_private_key.pem -pubout -out key_fim_root_public_key.pem

 Output:
 >read EC key
 >
 >writing EC key

###### Create FIM private CSK1:

 >[PACSign_Demo]$ openssl ecparam -name secp256r1 -genkey -noout -out key_fim_csk1_private_key.pem

 Output:

 > using curve name prime256v1 instead of secp256r1

###### Create FIM public CSK1:

 >[PACSign_Demo]$ openssl ec -in key_fim_csk1_private_key.pem -pubout -out key_fim_csk1_public_key.pem

 Output:
 >read EC key
 >
 >writing EC key

###### Create FIM private CSK2:

 >[PACSign_Demo]$ openssl ecparam -name secp256r1 -genkey -noout -out key_fim_csk2_private_key.pem

 Output:

 > using curve name prime256v1 instead of secp256r1

###### Create FIM public CSK2:

 >[PACSign_Demo]$ openssl ec -in key_fim_csk2_private_key.pem -pubout -out key_fim_csk2_public_key.pem

 Output:
 >read EC key
 >
 >writing EC key

##### 2. BMC keys creation:

###### BMC private key:


>[PACSign_Demo]$ openssl ecparam -name secp256r1 -genkey -noout -out key_bmc_root_private_key.pem

 Output:
 
 > using curve name prime256v1 instead of secp256r1


###### BMC public key:

 >[PACSign_Demo]$ openssl ec -in key_bmc_root_private_key.pem -pubout -out key_bmc_root_public_key.pem

 Output:
 >read EC key
 >
 >writing EC key

###### Create BMC private CSK1:

 >[PACSign_Demo]$ openssl ecparam -name secp256r1 -genkey -noout -out key_bmc_csk1_private_key.pem

 Output:

 > using curve name prime256v1 instead of secp256r1

###### Create BMC public CSK1:

 >[PACSign_Demo]$ openssl ec -in key_bmc_csk1_private_key.pem -pubout -out key_bmc_csk1_public_key.pem

 Output:
 >read EC key
 >
 >writing EC key

###### Create BMC private CSK2:

 >[PACSign_Demo]$ openssl ecparam -name secp256r1 -genkey -noout -out key_bmc_csk2_private_key.pem

 Output:

 > using curve name prime256v1 instead of secp256r1

###### Create BMC public CSK2:

 >[PACSign_Demo]$ openssl ec -in key_bmc_csk2_private_key.pem -pubout -out key_bmc_csk2_public_key.pem

 Output:
 >read EC key
 >
 >writing EC key

#### 3.5.2 HSM Key Creation
<a name="hsm-key-creation"></a>

If you are using an HSM, you need one token to create and store the root and code signing keys. The following example initializes a token using SoftHSM, with separate security officer and user PINs.
  >[PACSign_Demo]$ softhsm2-util --init-token --label pac-hsm --so-pin hsm-owner -- pin pac-fim-signer --free

  Output:
 >Slot 0 has a free/uninitialized token.
 >
 >The token has been initialized and is reassigned to slot 1441483598

After you create a token, you can create keys in that token. The following example initializes a root and two code signing keys in the token created above, similarly using pkcs11-tool to interact with SoftHSM. The HSM, not PACSign, uses the key ID provided in this example. PACSign uses CSK IDs from a configuration  \*.json file in PKCS11 mode. You must manage consistency across ID values in the HSM and those used by PACSign. See the *PACSign PKCS11 Manager \*.json Reference* topic for more information on the \*.json file format.

1. Initialize the root key:

 >[PACSign_Demo]$ pkcs11-tool --module=/usr/local/lib/softhsm/libsofthsm2.so --token-label pac-hsm --login --pin pac-fim-signer --keypairgen --mechanism ECDSA-KEY-PAIR-GEN --key-type EC:secp256r1 --usage-sign --label root_key --id 0

 Output:
 >Key pair generated:
 >
 >Private Key Object; EC
 >
 >label: root_key
 >
 >ID: 00
 >
 >Usage: decrypt, sign, unwrap
 >
 >Public Key Object; EC EC_POINT 256 bits
 >
 >EC_POINT:
 >
 >0441043d3756347e6c257dac085574cc1cd984cdeee2c1059a0f035dabc3ad6e1950c8717dc7 ac8451a90c2471e95f4a69d6517f02f678830280f90a479c76a3e95d64
 >
 >EC_PARAMS: 06082a8648ce3d030107
 >
 >label: root_key
 >
 >ID: 00
 >
 >Usage: encrypt, verify, wrap

2. Initialize the CSK1:

 >[PACSign_Demo]$ pkcs11-tool --module=/usr/local/lib/softhsm/libsofthsm2.so --token-label pac-hsm --login --pin pac-fim-signer --keypairgen --mechanism
 \
 ECDSA-KEY-PAIR-GEN --key-type EC:secp256r1 --usage-sign --label csk_1 --id 1

 Output:
 >Key pair generated:
 >
 >Private Key Object; EC
 >
 >label: csk_1
 >
 >ID: 01
 >
 >Usage: decrypt, sign, unwrap
 >
 >Public Key Object; EC EC_POINT 256 bits
 >
 >EC_POINT:
0441041a827c903b5da8478c81fe652208704f0621b984190cd961ee154ac5c3ba772d1caa26 964a189262ee31b8e5d77898f293c0589b350103037b664d31adf68924
 >
 >EC_PARAMS: 06082a8648ce3d030107
 >
 >label: csk_1
 >
 >ID: 01
 >
 >Usage: encrypt, verify, wrap

3. Initialize CSK2:

 >[PACSign_Demo]$ pkcs11-tool --module=/usr/local/lib/softhsm/libsofthsm2.so --token-label pac-hsm --login --pin pac-fim-signer --keypairgen --mechanism
 \
 ECDSA-KEY-PAIR-GEN --key-type EC:secp256r1 --usage-sign --label csk_2 --id 2

 Output:

 >Key pair generated:
 >
 >Private Key Object; EC
 >
 >label: csk_2
 >
 >ID: 02
 >
 >Usage: decrypt, sign, unwrap
 >
 >Public Key Object; EC EC_POINT 256 bits
 >
 >EC_POINT:
 04410495f7556912d8753cf873be7a54e7d88c28bca672496abd90d9b44cc95cf50df9169b7a d043a7340003a2bf96cb461e0575319b541ceb5d873d06334b30d208cc
 >
 >EC_PARAMS: 06082a8648ce3d030107
 >
 >label: csk_2
 >
 >ID: 02
 >
 >Usage: encrypt, verify, wrap

4. After keys are created in your token, it may be useful to inspect the token to verify the expected keys, labels, and IDs are present.

 >[PACSign_Demo]$ pkcs11-tool --module=/usr/local/lib/softhsm/libsofthsm2.so
--token-label pac-hsm --login --pin pac-fim-signer -O

 Output:
 >Public Key Object; EC EC_POINT 256 bits
 >
 >EC_POINT:
 >04410495f7556912d8753cf873be7a54e7d88c28bca672496abd90d9b44cc95cf50df9169b7a d043a7340003a2bf96cb461e0575319b541ceb5d873d06334b30d208cc
 >
 >EC_PARAMS: 06082a8648ce3d030107
 >
 >label: csk_2
 >
 >ID: 02
 >
 >Usage: encrypt, verify, wrap
 >
 >Public Key Object; EC EC_POINT 256 bits
 >
 >EC_POINT:
0441043d3756347e6c257dac085574cc1cd984cdeee2c1059a0f035dabc3ad6e1950c8717dc7 ac8451a90c2471e95f4a69d6517f02f678830280f90a479c76a3e95d64
 >
 >EC_PARAMS: 06082a8648ce3d030107
 >
 >label: root_key
 >
 >ID: 00
 >
 >Usage: encrypt, verify, wrap
 >
 >Private Key Object; EC
 >
 >label: root_key
 >
 >ID: 00
 >
 >Usage: decrypt, sign, unwrap
 >
 >Private Key Object;
 >
 >EC label: csk_2
 >
 >ID: 02
 >
 >Usage: decrypt, sign, unwrap
 >
 >Private Key Object;
 >
 >EC label: csk_1
 >
 >ID: 01
 >
 >Usage: decrypt, sign, unwrap
 >
 >Public Key Object; EC EC_POINT 256 bits
 >
 >EC_POINT:
0441041a827c903b5da8478c81fe652208704f0621b984190cd961ee154ac5c3ba772d1caa26 964a189262ee31b8e5d77898f293c0589b350103037b664d31adf68924
 >
 >EC_PARAMS: 06082a8648ce3d030107
 >
 >label: csk_1
 >
 >ID: 01
 >
 >Usage: encrypt, verify, wrap

#### Related Information

[PACSign PKCS11 Manager \*.json Reference](#pacsign-pkcs11-manager-.json-reference)

### 3.6 Root Entry Hash Bitstream Creation
<a name="root-entry-hash-bitstream-creation"></a>

In order to program the root entry hash to your Intel OFS platform, you must use PACSign to create a root entry hash bitstream.

1. In your *PACSign* command, specify the type *RK_256* and select the appropriate HSM manager and configuration.

    - To create a root entry hash bitstream using OpenSSL and the key generated in the *OpenSSL Key Creation* topic, type:

   
    FIM Root Entry Hash:

    >[PACSign_Demo]$ PACSign FIM -t RK_256 -H openssl_manager -r key_fim_root_public_key.pem -o fim_root_public_program_ssl.bin

    BMC Root Entry Hash:

    >[PACSign_Demo]$ PACSign BMC -t RK_256 -H openssl_manager -r key_bmc_root_public_key.pem -o bmc_root_public_program_ssl.bin

   
> *Note:* PACSign requires an HSM configuration \*.json file to request the correct key from the HSM. For more information about the structure and contents of the \*.json file, refer to the *PACSign PKCS11 Manager .json Reference* topic.

2. After creating the root entry hash bitstream, program the bitstream to the platform using the fpgasupdate command. This operation is permanent and irreversible. After an image root entry hash bitstream is programmed, the platform validates an image signature prior to loading. For more details on key management, see the *Key Management* topic.

3. Perform RSU command

    >[PACSign_Demo]$ sudo rsu bmcimg b:d.f    

#### Related Information

-   [PACSign PKCS11 Manager \*.json Reference](#pacsign-pkcs11-manager-.json-reference)

-   [HSM Key Creation](#hsm-key-creation)

-   [Key Management](#key-management)

### 3.7 Signing Images
<a name="signing-images"></a>

After the root and code signing keys have been created, you may sign your BMC, FIM, and Flat image. Use the BMC or SR bitstream type with the UPDATE identifier to perform this operation, and specify the HSM configuration, root key, code signing key, and image input and output file names.
The following example demonstrates image signing using *OpenSSL* and the root and code signing keys generated in *OpenSSL Key Creation* topic.
 >[PACSign_Demo]$ PACSign FIM -t UPDATE -H openssl_manager -r key_fim_root_public_key.pem -k key_fim_csk1_public_key.pem -i unsigned_FIM.bin -o FIM_signed_ssl.bin

The following example demonstrates image signing using SoftHSM PKCS11 and the root and code signing keys generated in *HSM Key Creation* topic. Refer to the PACSign PKCS11 Manager .json Reference topic for more information on the **.json* file used.
 >[PACSign_Demo]$ PACSign FIM -t UPDATE -H pkcs11_manager -C softhsm.json -r root_key -k csk_1 -i unsigned_FIM.bin -o FIM_signed_hsm.bin

You can program signed bitstreams on your platform by using the fpgasupdate tool and performing a remote system update. Your Intel OFS Platform only authenticates signed bitstreams after a root entry hash bitstream has been
programmed. The platform that has not been programmed with a root entry hash bitstream accepts a signed bitstream and ignores the contents of the signature chain.

If you sign your image with a cancelled CSK and attempt to program the platform, the BMC recognizes the bitstream as corrupted, reports an error and you must power cycle the platform to recover the card.

#### Related Information

- [OpenSSL Key Creation](#openssl-key-creation)

- [HSM Key Creation](#hsm-key-creation)

- [PACSign PKCS11 Manager \*.json Reference](#pacsign-pkcs11-manager-.json-reference)

## 3.8 Creating a CSK ID Cancellation Bitstream
<a name="creating-a-csk-id-cancellation-bitstream"></a>
To cancel a CSK ID on your Intel OFS platform, you must use PACSign to create a CSK ID cancellation bitstream. To do this, you must specify the type CANCEL, select the appropriate HSM manager and root key, and provide the key ID number to cancel. For OpenSSL, the key ID used during image signing is derived from the CSK filename. For PKCS11, the key ID used during image signing is extracted from the
configuration .json

1. Create a cancellation bitstream.

Using OpenSSL:

>[PACSign_Demo]$ PACSign FIM -t CANCEL -H openssl_manager -r key_fim_root_public_key.pem -d 1 -o ssl_csk1_cancel.gbs

Using PKCS11:

>[PACSign_Demo]$ PACSign FIM -t CANCEL -H pkcs11_manager -C softhsm.json -r root_key -d 1 -o hsm_csk1_cancel.gbs

2. Program the CSK ID cancellation on your Intel OFS platform using the fpgasupdate tool.

>fpgasupdate ssl_csk1_cancel.bin b2:00.0

CSK ID cancellation bitstreams are only valid on Intel FPGA PACs that have been programmed with the corresponding root entry hash bitstream.
After you program a CSK ID cancellation bitstream, you must power cycle the platform.

### 3.9 PACSign PKCS11 Manager \*.json Reference
<a name="pacsign-pkcs11-manager-.json-reference"></a>

The PACSign PKCS11 Manager uses a \*.json file that stores information on how to interact with your HSM.

It contains information specific to your HSM, as well as a description of the token and keys that you created for use with PACSign. The PKCS11 examples in this chapter use *softhsm.json* 


The *cryptoki_version* and *library_version* information is determined by your HSM and can be reported by pkcs11-tool:

> \[PACSign_Demo\]\$ pkcs11-tool --module=/usr/local/lib/softhsm/libsofthsm2.so -I

Output:
 >Cryptoki version 2.40
 >
 >Manufacturer SoftHSM
 >
 >Library Implementation of PKCS11 (ver 2.5)
 >
 >Using slot 0 with a present token (0x55eb4b4e)


### 3.10 Creating a Custom HSM Manager
<a name="creating-a-custom-hsm-manager"></a>

PACSign is a Python tool that uses a plugin architecture for the HSM interface. PACSign is distributed with managers for both OpenSSL and PKCS \#11. This section describes the functionality required by PACSign from the HSM interface and shows how to construct a plugin.

The distribution of PACSign uses the following directory structure:

>hsm_managers
>
    > openssl_manager
        >
        > library
        >
    > pkcs11_manager
    >
>source

The top level contains PACSign.py with the generic signing code in source. The HSM managers reside each in their own subdirectory under hsm_managers as packages. The directory name is what is given to PACSign's \--HSM_MANAGER command-line option. If the specific manager requires additional information, you can provide it using the optional \--HSM_config command-line option. For example, the PKCS \#11 plugin requires a \*.json file describing the tokens and keys available on the HSM.

You must place each plugin that is to be supported in a subdirectory of the hsm_managers directory. Use a descriptive name for the directory that clearly describes the supported HSM. This subdirectory may have an *init_.py* file whose contents import the modules needed by the plugin. The names of the plugin modules are not important to the proper functioning of PACSign.

The newly-created plugin must be able to export one attribute named HSM_MANAGER that is invoked by PACSign with an optional configuration file name provided on the command-line. Invocation of *HSM_MANAGER*(config_file) returns a class with certain methods exposed, which are described in later sections.

Current implementations of *HSM_MANAGER* define it as a Python class object. The initialization function of the class reads and parses the configuration file (if present) and performs HSM initialization. For the PKCS \#11 implementation, the class looks like this:

>class HSM_MANAGER(object):
>
>def init (self, cfg_file = None):
>
>common_util.assert_in_error(cfg_file, \
>
> PKCS11 HSM manager requires a configuration file")
>
>self.session = None
>
>with open(cfg_file, "r") as read_file:
>
> self.j_data = json.load(read_file)
>
>j_data = self.j_data
>
>lib = pkcs11.lib(j_data['lib_path'])
>
>token = lib.get_token(token_label=j_data['token']['label'])
>
>self.session = token.open(user_pin=j_data['token']['user_password'])
>
>self.curve = j_data['curve']
>
>self.ecparams = self.session.create_domain_parameters(pkcs11.KeyType.EC, {pkcs11.Attribute:pkcs11.util.ec.encode_named_curve_parameters(self.curve)},local=True)

Error handling code has been omitted for clarity. This code

- Opens and parses the \*.json configuration file.

- Loads the vendor-supplied PKCS \#11 library into the program.

- Sets up a session with the correct token.

- Retrieves the proper elliptic curve parameters for the curve you select. The following sections describe the required exported methods of this class.

#### 3.10.1 HSM_MANAGER.get_public_key(public_key)
<a name="hsm_manager.get_public_keypublic_key"></a>

This method returns an instance of a public key that is described by 'public_key', which was provided via a command-line option (\--root_key or \-- code_signing_key). The HSM manager must know how to properly identify the key on the HSM given this string.

The public key instance is required to supply the public methods described in the sections that follow. The PKCS \#11 implementation of this function, get_public_key, is below:

>def get_public_key(self, public_key):
>
>try:
>
>key_, local_key = self.get_key(public_key, ObjectClass.PUBLIC_KEY)
>
>key_= key_[Attribute.EC_POINT]
>
>except pkcs11.NoSuchKey:
>
>pass # No key found
>
>except pkcs11.MultipleObjectsReturned:
>
>pass # Multiple keys found
>
>return _PUBLIC_KEY(key_[3:], local_key)

##### 3.10.1.1 PUBLIC_KEY.get_X\_Y()

This function returns a *common_util.BYTE_ARRAY()* that contains the elliptic curve point associated with the key. The returned value should be X concatenated with Y, each with the proper number of bytes. For our implementation, each of X and Y are 32 bytes (256 bits) because secp256r1 curve parameters are required.

##### 3.10.1.2 PUBLIC_KEY.get_permission()

Intel FPGA PAC keys have associated permissions. This function returns an integer that corresponds to the assigned key permissions. For Intel FPGA PACs, all root key permissions must be the constant *0xFFFFFFFF*. For code signing keys, the permissions are described below.

#### Table 5. Key Permissions

**Value** |  **Name** |  **Permission**
----------|-----------|-------------------
1         | SIGN_SR    | Sign the FIM
2         | SIGN_BMC   | Sign the card BMC Nios firmware and/or the Intel MAX 10 image|

##### 3.10.1.3 PUBLIC_KEY.get_ID()

Your customer Intel OFS platform have a laddering key mechanism that allows for cancellation of code signing keys. This method returns the integer key ID of the specified key. The root key ID must be the constant *0xFFFFFFFF*. Root keys cannot be canceled.


##### 3.10.1.4 PUBLIC_KEY.get_content_type()

Code signing keys and root keys can be restricted to signing only certain types of content. For instance, there are separate root keys for PR, SR, and BMC bitstreams as well as corresponding code signing keys. This method should return the bitstream type associated with this key, and must be one of *{FIM, SR, BBS, BMC, BMC_FW, AFU, PR, or GBS}*.

#### 3.10.2 HSM_MANAGER.sign(data, key)
<a name="hsm_manager.signdata-key"></a>

This method uses the key provided to generate an ECDSA signature over the provided data.
The return value of this method is a *common_util.BYTE_ARRAY()* containing the R and S values of the signature concatenated. PACSign only signs hashes, so the length of the data to be signed will be a fixed-length 32 byte array.

#### 3.10.3 Signing Operation Flow
<a name="signing-operation-flow"></a>

A PACSign command that invokes the PKCS \#11 manager plugin initializes it with the configuration file name.

PACSign performs insertion of authentication blocks into the bitstream, signed by the root and code signing keys. The resultant signed bitstream is written to the specified output file.

PACSign requests that the HSM manager retrieve the public key X and Y values for the root key and the code signing key. The HSM manager returns the R and S signature over PACSign-provided 256-bit hash values using the root key and code signing key.

The following code snippet demonstrates how PACSign utilizes the HSM manager.

```powershell
*self.pub_root_key_c = self.hsm_manager.get_public_key(args.root_key) common_util.

assert_in_error(self.pub_root_key_c, \

"Cannot retrieve root public key")
    self.pub_root_key = self.pub_root_key_c.get_X_Y()

    self.pub_root_key_perm = self.pub_root_key_c.get_permission()

    self.pub_root_key_id = self.pub_root_key_c.get_ID()

    self.pub_root_key_type = self.pub_root_key_c.get_content_type()

self.pub_CSK_c = self.hsm_manager.get_public_key(args.code_signing_key)

common_util.assert_in_error(self.pub_CSK_c != None, \

"Cannot retrieve public CSK")
    self.pub_CSK = self.pub_CSK_c.get_X_Y()

    self.pub_CSK_perm = self.pub_CSK_c.get_permission()

    self.pub_CSK_id = self.pub_CSK_c.get_ID()

    self.pub_CSK_type = self.pub_CSK_c.get_content_type()

sha = sha256(block0.data).digest()

rs = self.hsm_manager.sign(sha, args.code_signing_key) sha = sha256(csk_body.data).digest()

rs = self.hsm_manager.sign(sha, args.root_key)*
```

### 3.11 PACSign Man Page
<a name="pacsign-man-page"></a>

PACSign man page is reproduced here for convenience.

> *Static FPGA image BMC(BMC_FW)
>
> BMC image, including firmware for some PACs PR (AFU, GBS)
>
> Reconfigurable FPGA image
>
> REQUIRED OPTIONS
>
> All bitstream types are required to include an action to be performed
> by PACSign and the name and optional parameter file for a key signing
> module.
>
> -t, \--cert_type \<type\>
>
> Values must be one of UPDATE, CANCEL, RK_256, or RK_384\[\^1\].
>
> \`UPDATE\` - add authentication data to the bitstream.
>
> \`CANCEL\` - create a code signing key cancellation bitstream.
>
> \`RK_256\` - create a bitstream to program a 256-bit root key to the
> device.
>
> \`RK_384\` - create a bitstream to program a 384-bit root key to the
> device. \[\^1\]:Current PACs do not support 384-bit root keys.
>
> -H, \--HSM_manager \<module\>
>
> The module name for a manager that is used to interface to an HSM.
> PACSign supplies both openssl_manager and pkcs11_manager to handle
> keys and signing operations.
>
> -C, \--HSM_config \<cfg\> (optional)
>
> The argument to this option is passed verbatim to the specified HSM
> manager. For pkcs11_manager, this option specifies a JSON file
> describing the PKCS \#11 capable HSM\'s parameters.
>
> OPTIONS
>
> -r, \--root_key \<keyID\>
>
> The key identifier recognizable to the HSM manager that identifies the
> root key to be used for the selected operation.
>
> -k, \--code_signing_key \<keyID\>
>
> The key identifier recognizable to the HSM manager that identifies the
> code signing key to be used for the selected operation.
>
> -d, \--csk_id \<csk_num\>
>
> Only used for type CANCEL and is the key number of the code signing
> key to cancel.
>
> -i, \--input_file \<file\>
>
> Only used for UPDATE operations. Specifies the file name containing
> the data to be signed.
>
> -o, \--output_file \<file\>
>
> Specifies the name of the file to which the signed bitstream is to be
> written.
>
> -y, \--yes
>
> Silently answer all queries from PACSign in the affirmative.
>
> -v, \--verbose
>
> Can be specified multiple times. Increases the verbosity of PACSign.
> Once enables non-fatal warnings to be displayed; twice enables
> progress information. Three or more occurrences enables very verbose
> debugging information.
>
> NOTES
>
> Different certification types require different sets of options. The
> table below describes which options are required based on
> certification type:
>
> UPDATE
>
 |- |root_key | code_signing_key | csk_id |input_file |output_file
|---|-----------|------------------|--------|-----------|-------------
SR |Optional\[\^2\] |Optional\[\^2\] |No |Yes |Yes
BMC| Optional\[\^2\] |Optional\[\^2\] |No |Yes |Yes
PR |Optional\[\^2\] |Optional\[\^2\] |No |Yes |Yes
>
> CANCEL
>
 |- |root_key | code_signing_key | csk_id |input_file |output_file
|---|-----------|------------------|--------|-----------|-------------
SR |Yes |No |Yes |No |Yes
BMC |Yes |No |Yes |No |Yes
PR |Yes |No |Yes |No |Yes
>
> RK_256 / RK_384\[\^1\]
>
 |-|root_key | code_signing_key | csk_id |input_file |output_file
|---|-----------|------------------|--------|-----------|-------------
SR |Yes |No |No |No |Yes
BMC |Yes |No |No |No |Yes
PR |Yes |No |No |No |Yes
>
> \[\^2\]: For UPDATE type, both keys must be specified to produce an
> authenticated bitstream. Omitting one key generates a valid, but
> unauthenticated bitstream that can only be loaded on a PAC with no
> root key programmed for that type.
>
> EXAMPLES
>
> The following command will generate a root hash programming PR
> bitstream. The generated file can be given to fpgasupdate to program
> the root hash for PR operations into the device flash. Note that root
> hash programming can only be done once on a PAC.
>
> python PACSign.py PR -t RK_256 -o pr_rhp.bin -H openssl_manager -r
> key_pr_root_public_256.pem
>
> The following command will add authentication blocks to hello_afu.gbs
> signed by both provided keys and write the result to s_hello_afu.gbs.
> If the input bitstream were already signed, the old signature block is
> replaced with the newly-generated block.
>
> python PACSign.py PR -t update -H openssl_manager -i hello_afu.gbs -o
> s_hello_afu.gbs -r key_pr_root_public_256.pem -k
> key_pr_csk0_public_256.pem
>
> The following command will generate a code signing key cancellation
> bitstream to cancel code signing key 4 for all BMC operations. CSK 4
> bitstreams that attempt to load BMC images will be rejected by the
> PAC.
>
> python PACSign.py BMC -t cancel -H openssl_manager -o csk4_cancel.gbs
> -r key_bmc_root_public_256.pem -d 4*


## 4. Using fpgasupdate
<a name="using-fpgasupdate"></a>

Use the fpgasupdate command to securely update the following files in flash:

- BMC Nios firmware and Intel MAX 10 FPGA images

- FIM images

- AFU (partial reconfiguration) images

When you call fpgasupdate the BMC orchestrates the update.

- The BMC restricts all access to the flash until the fpgasupdate tool sends a request to the BMC to begin the update process.

- The BMC rejects an update request if another update is currently in progress. The BMC monitors flash write and update counts and delays an update 30 seconds if more than 1,000 updates have occurred, and 60 seconds if more than 2,000 updates have occurred.

- The BMC grants access only to a staging area in the flash, and only for enough time for the host to write an update into the staging area.

- The BMC then restricts all flash write access to ensure the update image cannot be changed during or after the authentication process.

- During the fpgasupdate process, the Nios in the BMC stops polling the sensors and updating the platform level data model (PLDM) registers but responds to PLDM requests. Thus, any PLDM reads or fpgad polling during fpgasupdate returns stale data from before the update began.

- If authentication is successful, the BMC copies the image from the staging area into the appropriate section in flash.

To use the command type:

> \$ sudo fpgasupdate \[\--log-level=*\<level\>*\] *file \[bdf\]*

where the following options are as follows:

**Parameters** | **Options**          | **Notes**
---------------|----------------------|--------------
level            | state, ioctl, debug, info, warning, error, critical. Default value is state.   |
file             | The secure update file that you program in the Intel FPGA PAC |
\[bdf\]          | \[ssss:\]bb:dd:f,corresponding to PCIe  segment, bus, device, function. The segment is optional; if omitted, a segment of 0000 is assumed     | If there is only one Intel FPGA PAC in the system, then bdf may be omitted. In this case, fpgasupdate determines the address automatically.

### 4.1. Troubleshooting
<a name="troubleshooting"></a>

*fpgasupdate* provides descriptive errors when it cannot complete the requested operation.

When using *fpgasupdate* to program bitstreams created or signed with PACSign, the tool may reject the bitstream if, for example, there was an error in the signing process or if the signed bitstream is corrupted. The OPAE driver reports the BMC doorbell and authentication status register values into the system messages log. You may find this log file in a location such as */var/log/messages* or */etc/syslog* depending on the OS you are using. The error entry contains the keywords intel-max10. An example of output in the log file might look something like this:

> \[ 4971.546624\] intel-max10 spi2.0: RSU error status: 8\'h10022104

> \[4971.548681\] intel-max10 spi2.0: RSU auth result: 8\'h00000011

In this example the error status value, bit\[23:16\] is the RSU error value to reference in the *BMC Doorbell Register Values and Error Descriptions* table.

You may use the following tables to decode the authentication status and associated errors.

#### Table 7. BMC Doorbell Register Values and Error Descriptions

| RSU-error [23:16] Value | Status Name                                  | Status Description                                                        | Corrective Action                                              |
|------------------------- |--------------------------------------------- |-------------------------------------------------------------------------- |--------------------------------------------------------------- |
| 8'h00                    | Normal status                                | -                                                                         | Not applicable.                                                |
| 8'h01                    | Host timeout                                 | Flow Error: Host timeout sending bitstream. Possible OS or system issue.  | Attempt sending bitstream again.                               |
| 8'h02                    | Authentication failure                       | -                                                                         | Ensure bitstream is properly signed with the correct keys.     |
| 8'h03                    | Image copy failure                           | Flow Error: Image copy failure                                            | Attempt copy again. If issue persists, contact Intel support.  |
| 8'h04                    | Fatal, error, Nios boot-up failure         | -                                                                        | Contact Board developer.                                        |
| 8'h05                   | Reserved                                    | -                                                                        | -                                                             |
| 8'h06                   | Staging area non- incremental write failure | -                                                                        | Contact Board developer.                                           |
| 8'h07                   | Staging area erase failure                  | -                                                                        | Contact Board developer.                                         |
| 8'h08                   | Staging area write wearout                  | -                                                                      | Contact Board developer.                                         |
| 8'h80                   | Nios boot OK                                | -                                                                        | Not applicable.                                               |
| 8'h81                   | Update OK                                   | Update image okay                                                        | Not applicable.                                               |
| 8'h82                   | Factory OK                                  | Factory image okay                                                       | Not applicable.                                               |
| 8'h83                   | Update Failure                              | -                                                                        | Contact Board developer.                                         |
| 8'h84                   | Factory Failure                             | -                                                                        | Contact Board developer.                                         |
| 8'h85                   | Nios Flash Open Error                       | -                                                                        | Contact Board developer.                                         |
| 8'h86                   | FPGA Flash Open Error                       | -                                                                        | Contact Board developer.                                         |
| Others                  | Reserved                                    | -                                                                        | -                                                             |

The errors in the following Authentication Status Register table are for failures that occur when programming the root entry hash bitstream or the cancellation key bitstream. These error types might occur if, for example, a root entry hash bitstream is signed with the incorrect key. These registers and the log files do not capture errors for signed image bitstream programming. If you run fpgasupdate and encounter errors, you must verify your image bitstream was signed with a CSK that is compatible with the root entry hash that is programmed on your Intel OFS platform. When an image fails to load on the platform you see this error message:

To recover from this error, you must power cycle the platform.

#### Table 8. Authentication Status Register Values and Error Descriptions

| Authentication Status Value | Error Name                                                        | Error Description                                                                                                        | Corrective Action                                          |
|-----------------------------|-------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------|
| 32'h00000000                | Authenticate Pass                                                 | Authenticate Pass                                                                                                        | Not applicable.                                            |
| 32'h00000001                | Block0 Magic value error                                          | Bitstream Format Error: Block 0 bad magic number. Indicates bitstream corruption.                                        | Ensure bitstream is properly signed with the correct keys. |
| 32'h00000002               | Block0 ConLen error                                               | Bitstream Format Error: Block 0 content length error. Indicates bitstream corruption.                                    | Ensure bitstream is properly signed with the correct keys. |
| 32'h00000003                | Block0 ConType B[7:0] > 2                                         | Bitstream Format Error: Block 0 content type error. Indicates bitstream corruption.                                      | Ensure bitstream is properly signed with the correct keys. |
| 32'h00000004                | Block1 Magic value error                                          | Bitstream Format Error: Block 1 bad magic number. Indicates bitstream corruption.                                        | Ensure bitstream is properly signed with the correct keys. |
| 32'h00000005                | Root Entry Magic value error                                      | Bitstream Format Error: Root entry bad magic number. Indicates bitstream corruption.                                     | Ensure bitstream is properly signed with the correct keys. |
| 32'h00000006                | Root Entry Curve Magic value error                                | Bitstream Format Error: Root entry bad curve magic number. Indicates bitstream corruption.                               | Ensure bitstream is properly signed with the correct keys. |
| 32'h00000007                | Root Entry Permission error                                       | Root entry bad permissions. Indicates bitstream corruption.                                                              | Ensure bitstream is properly signed with the correct keys. |
| 32'h00000008                | Root Entry Key ID error                                           | Bitstream Format Error: Root entry bad key ID. Indicates bitstream corruption.                                           | Ensure bitstream is properly signed with the correct keys. |
| 32'h00000009                | CSK Entry Magic value error                                       | Bitstream Format Error: CSK bad magic number. Indicates bitstream corruption.                                            | Ensure bitstream is properly signed with the correct keys. |
| 32'h0000000A                | CSK Entry Curve Magic value error                                 | Bitstream Format Error: CSK bad curve magic number.                                                                      | Ensure bitstream is properly signed with the correct keys. |
| 32'h0000000B                | CSK Entry Permission error                                        | Authentication Error: CSK bad permission. Indicates bitstream corruption.                                                | Ensure bitstream is properly signed with the correct keys. |
| 32'h0000000C                | CSK Entry Key ID error                                            | Bitstream Format Error: CSK invalid key ID, Indicates bitstream corruption.                                              | Ensure bitstream is properly signed with the correct keys. |
| 32'h0000000D                | CSK Entry Signature Magic value error                             | Bitstream Format Error: CSK bad signature magic number. Indicates bitstream corruption.                                  | Ensure bitstream is properly signed with the correct keys. |
| 32'h0000000E                | Block0 Entry Magic value error                                    | Bitstream Format Error: Block 0 entry bad magic number. Indicates bitstream corruption.                                  | Ensure bitstream is properly signed with the correct keys. |
| 32'h0000000F                | Block0 Entry Signature Magic value error                          | Bitstream Format Error: Block 0 entry bad signature magic number. Indicates bitstream corruption.                        | Ensure bitstream is properly signed with the correct keys. |
| 32'h00000010                | Root Entry Hash bitstream not programmed for RSU and Cancellation | Authentication error: Cancellation attempted with no root entry hash bitstream programmed.                               | Program root entry hash bitstream.                         |
| 32'h00000011                | Root Entry verify SHA failed                                      | Authentication Error: Root hash mismatch.                                                                                | Ensure bitstream is properly signed with the correct keys. |
| 32'h00000012                | CSK Entry verify ECDSA and SHA failed                             | Authentication Error: CSK signature invalid. Indicates CSK or root entry hash tampering.                                 | Ensure bitstream is properly signed with the correct keys. |
| 32'h00000013                | Block0 Entry verify ECDSA and SHA failed                          | Authentication Error: Block 0 entry signature invalid. May indicate image tampering.                                     | Ensure bitstream is properly signed with the correct keys. |
| 32'h00000014                | KEY ID of authenticate blob is invalid                            | Bitstream Format Error: CSK invalid key ID. Indicates you are using an ID value greater than what is allowed.            | Ensure bitstream is properly signed with the correct keys. |
| 32'h00000015                | KEY ID is cancelled                                               | Authentication Error: CSK canceled. Indicates you are attempting to program an image with a cancelled CSK.               | Ensure bitstream is properly signed with the correct keys. |
| 32'h00000016                | Update content SHA verify failed                                  | Authentication Error: Payload SHA mismatch. May indicate tampering of the bitstream.                                     | Verify correctness of bitstream; may need to resign.       |
| 8'h00000017                 | Cancellation content SHA verify failed                            | Authentication Error: Payload SHA mismatch. May indicate tampering of the cancellation certificate.                      | Verify correctness of bitstream; may need to resign.       |
| 8'h00000018                 | HASH Programming content SHA verify failed                        | Authentication Error: Payload SHA mismatch. May indicate tampering of the root key.                                      | Verify correctness of bitstream; may need to resign.       |
| 8'h00000019                 | Invalid cancellation ID of cancellation certificate               | Bitstream Format Error: CSK invalid key ID                                                                               | Verify correctness of bitstream; may need to resign.       |
| 8'h0000001A                 | KEY hash has been programmed for KEY hash programming certificate | Authentication Error: Attempt to program root entry hash when the root entry hash bitstream has already been programmed. | You may only program root entry hash bitstream one time.   |
| 8'h0000001B                 | Invalid operation of Block0 ConType                               | -                                                                                                                        | Contact Intel support.                                     |
| 8'h000000FF                 | Generic Authentication Failure                                    | -                                                                                                                        | Contact Intel support.                                     |

## 5. Intel® Open FPGA Stack 
<a name="ofs"></a>
For Intel® Open FPGA Stack, four images are available:
1. BMC
2. FIM
3. AFU
4. Flat image  (FIM+AFU)

There are two differents bitstreams:
1. Unsigned
2. Signed

### 5.1 Accessing Intel FPGA PAC Version and Authentication Information
<a name="pacversion"></a>
Throughout product development and deployment, you may want to:
Verify the version of your Intel OFS platform with which you are developing or deploying
Identify or verify the root entry hash of your FPGA SR user image
Collect data about the number of times the Staging flash has been programmed to assess any potential threats like flash wear-out
Determine all cancellation CSK IDs you used for your FPGA SR user image
OPAE software provides three ways to obtain version or authentication information:

>fpgainfo security command

>sysfs files

>bitstreaminfo tool

#### 5.1.1 Using fpgainfo security Command
<a name="fpgainfosecurity"></a>

The fpgainfo security command provides the following key identifying information for your Intel® OFS platform and bitstreams:

|Output	                  |Description|
|-------------------------|--------------------------------------|
|FIM/SR root entry hash|	Root entry hash programmed by you. If you have not programmed the FPGA SR user image root entry hash, this output reports as “hash not programmed.”|
|BMC root entry hash|	Root entry hash programmed by Intel® .
|PR root entry hash	| AFU entry hash programmed by customer
|BMC flash update counter|	Indicates how many times the BMC flash has been updated. This data can be useful in detecting threats. Note: When the BMC flash counter reaches 1000, the Intel® MAX® 10 BMC does not allow writes for 30 seconds after device startup and between updates. When the BMC flash counter reaches 2000, the Intel® MAX® 10 BMC does not allow writes for 60 seconds after device startup and between updates.|
|FIM/SR CSK IDs cancelled|	Indicates the IDs of the FIM code signing keys that are cancelled.
|BMC CSK IDs cancelled|	Indicates the IDs of the BMC code signing keys that are cancelled.|
|AFU CSK IDs cancelled|	Indicates the IDs of the AFU code signing keys that are 

Using this command requires sudo or root privileges on your host.

> $ sudo fpgainfo security

>Board Management Controller, MAX10 NIOS FW version: 2.0.12 

>Board Management Controller, MAX10 Build version: 2.0.8 

>//****** SEC ******//

>Object Id                        : 0xED00000

>PCIe s:b:d.f                     : 0000:12:00.0

>Device Id                        : 0x0B2B

>Socket Id                        : 0x00

>Ports Num                        : 01

>Bitstream Id                     : 0x202000200000237

>Bitstream Version                : 2.0.2

>Pr Interface Id                  : 9346116d-a52d-5ca8-b06a-a9a389ef7c8d

>Boot Page                        : user

>********** SEC Info START ************ 

>BMC root entry hash: hash not programmed

>BMC CSK IDs canceled: None

>PR root entry hash: hash not programmed

>AFU/PR CSK IDs canceled: None

>FIM root entry hash: hash not programmed

>FIM CSK IDs canceled: None

>User flash update counter: 1

>********** SEC Info END ************


#### 5.1.2 Reading sysfs Files for Identifying Information
<a name="sysfs"></a>

The information provided by the fpgainfo security command is also available in sysfs entries. The sysfs entries are found in location:

/sys/class/ifpga_sec_mgr/ifpga_sec<X>/security

>$ls -l /sys/class/ifpga_sec_mgr/ifpga_sec<X>/security
>
>-r--r--r--. 1 root root 4096 Oct 21 02:08 bmc_canceled_csks
>
>-r--r--r--. 1 root root 4096 Oct 21 02:08 bmc_root_entry_hash
>
>-r--r--r--. 1 root root 4096 Oct 21 02:08 pr_canceled_csks
>
>-r--r--r--. 1 root root 4096 Oct 21 02:08 pr_root_entry_hash
>
>-r--r--r--. 1 root root 4096 Oct 21 02:08 sr_canceled_csks
>
>-r--r--r--. 1 root root 4096 Oct 21 02:08 sr_root_entry_hash
>
>-r--r--r--. 1 root root 4096 Oct 21 02:08 user_flash_count

Sysfs File List

|Sysfs File	|Output	|Description	|File Data Format|
|-----------|--------|---------------|----------------|
|sr_root_hash|	SR root entry hash	|Root entry hash programmed by Board Developer. If you have not programmed the FPGA SR user image root entry hash, this output reports as “hash not programmed.”	|Long hexadecimal output prefixed with “0x” or “hash not programmed” if the bitstreams is unsigned.|
|bmc_root_hash	|BMC root entry hash	|Root entry hash programmed by Board developer.	|Long hexadecimal output prefixed with “0x".
|pr_root_hash	|PR root entry hash	|Root entry hash programmed by customer	| NA| 
|user_flash_count|	User Flash update counter|	Indicates how many times the staging area flash is updated. has been updated. This data can be useful in detecting threats. Note: When the staging area flash counter reaches 1000, the Intel® MAX® 10 BMC does not allow writes for 30 seconds after device startup and between updates. When the BMC flash counter reaches 2000, the Intel® MAX® 10 BMC does not allow writes for 60 seconds after device startup and between updates.|Single, numeric value|
|sr_canceled_csks|	SR CSK IDs canceled	|Indicates the IDs of the FIM code signing keys that are cancelled.	|Comma-separated list of decimal numbers and ranges, such as: 0, 3-6, 8-10|
|bmc_canceled_csks	|BMC CSK IDs canceled	|Indicates the IDs of the BMC code signing keys that are cancelled.	|Comma-separated list of decimal numbers and ranges, such as: 0, 3-6, 8-10|
|pr_canceled_csks	|AFU CSK IDs canceled	|Indicates the IDs of the AFU code signing keys that are cancelled.	|Comma-separated list of decimal numbers and ranges, such as: 0, 3-6, 8-10

#### 5.1.3 Using bitstreaminfo Tool
<a name="bitstreaminfo"></a>

The bitstreaminfo tool also displays authentication information for *.bin files. Information includes any JSON header strings and authentication header block information. For FPGA SR user image bitstreams, the bitstreaminfo command also displays a small portion of the payload for FPGA SR user image bitstreams. The bitstreaminfo tool requires sudo or root privileges on your host:

$ sudo bitstreaminfo <file>

An example:

$ sudo bistreaminfo firmware.bin

This command displays the Block 0 and Block 1 content prepended by the PACSign tool to the FPGA SR user image. Depending on if your bitstream is signed or unsigned Block 1 output varies:

    Unsigned bitstream: Block 1 output reports 0x0 for Root public key X,Y and Code signing key X,Y.

    Signed bitstream: Block 1 output reports a value for Root public key X,Y and Code Signing key X,Y.

The magic number output in Block 0 and 1 are static values populated by PACSign

#### Block 0 Fields


|Parameter	|Description|
|-----------|-----------|
Content length|	Indicates the length of the FPGA SR user image. PACSign performs an internal check to see if the length is within the maximum length for your Intel® OFS platform.|
|Content type	|SR or BMC|
|Cert type	|For an FPGA SR user image, Cert type can be: <br><br>  - Update : Unsigned/signed FPGA SR user image <br> - Root Key Hash Programming : Root entry hash bitstream <br> - Cancellation Certificate : Cancelled Code Signing key ID bitstream for FPGA SR user image. After you program a cancellation certificate, the Intel® FPGA PAC prohibits you from loading any FPGA SR user image that was signed with the cancelled CSK ID. <br> <br>For an Intel® -provided bitstream, Cert type can be: <br><br> - Update : Signed BMC firmware or unsigned FPGA SR user image<br> - Cancellation Certificate : Cancelled Code Signing key ID bitstream for BMC. After you program a cancellation certificate, the platform prohibits you from loading any BMC bitstream that was signed with the cancelled CSK ID.
|Protected content SHA-256| SHA-256 is computed over the entire protected bitstream and it is compared against the SHA-256 calculated by PACSign and programmed into Block 0. You can check if bitstreaminfo reports a Match as shown below.
|Protected content SHA-384|	SHA-384 is computed over the entire protected bitstream and it is compared against the SHA-256 calculated by PACSign and programmed into Block 0. You can check if bitstreaminfo reports a Match as shown below. <br> Note: Current Intel® FPGA PAC N3000 versions do not support 384 bit root key but the tool computes the SHA-384 on the protected content.

#### Block 1 Fields

|Parameter	|Description|
|-----------|-----------|
|Root Entry Permissions	|Constant value: 0xffffffff
|Root Entry Key ID|	Constant value: 0xffffffff
|Root public key x,y|	Value populated if bitstream was signed using root key and CSK.
|Expected root entry hash|	Hash of all the root fields in Block 1 are computed. You can visually compare this against the FPGA SR user image root entry hash that is programmed into the card. fpgainfo security displays the FPGA SR user image root entry hash. If fpgainfo security reports "FIM/SR root entry hash not programmed", then the bitstreaminfo tool skips the compatibility check.
|CSK key ID	|The CSK ID can range from 0 - 127. fpgainfo security displays a list of CSK IDs canceled. If bitstream uses a CSK ID that matches the cancelled CSK ID, fpgasupdate prohibits programming the bitstream.
|Code signing key x,y	|Value reported if Bitstream was signed using root key and CSK.
|Signature R, S	|Signature over hash of CSK Public Key using private root key. Your HSM populates this signature.
|Expected CSK hash	|This field varies when the CSK ID changes. It is a hash of the CSK fields.
|Signature R, S	|Signature over hash of Block 0 using CSK private key.


## 6. Revision History
<a name="revision-history"></a>

**Document Version** | **Changes**
---------------------|-------------------------
2022.5.20           | Remove json file example
2021.8.18           | Initial production release
