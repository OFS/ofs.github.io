<div id="myBox">
  <h1>OFS Build Command Generator</h1><form id="myForm">
    <fieldset>
      <legend>Build Flow Options</legend>  
      <fieldset>
        <legend>Build Target</legend>
        <select id="select_build_target">
          <option value="n6001">n6001</option>
          <option value="n6000">n6000</option>
          <option value="fseries-dk">fseries-dk</option>
          <option value="iseries-dk">iseries-dk</option>
        </select><br>
      </fieldset>
    </fieldset>
    <fieldset>
      <legend>Partial Reconfiguration Settings</legend>
      <input type="checkbox" title="Disabling partial reconfiguration will build a flat design." id="check1" name="check_pr" value="check1">
      <label for="check1">Disable Partial Reconfiguration</label><br>
      <input type="checkbox" title="When this option is enabled the build script will automatically run the generate_pr_release.sh script after the design is compiled. This creates a self-contained working directory for a workload developer to create their AFU/workload." id="check2" name="check_proot" value="check2">
      <label for="check2">Generate Relocatable PR Tree</label><br>
    </fieldset>
    <fieldset>
      <legend>Add/Remove Subsystems</legend>
      <input type="checkbox" id="check8" name="check_no_hssi" value="check8">
      <label for="check8">Remove HSSI-SS (Ethernet Sub-System)</label><br>
    </fieldset>
    <fieldset>
      <legend>Add/Remove Host Exercisers</legend>
      <input type="checkbox" title="When checked the HE_HSSI is replaced with an HE_NULL which ties off the associated VF, leaving a stub with minimal registers." id="check3" name="check_null_he_hssi" value="check3">
      <label for="check3">Remove HE_HSSI (Ethernet Host Exerciser)</label><br>
      <input type="checkbox" title="When checked the HE_LBK is replaced with an HE_NULL which ties off the associated PF, leaving a stub with minimal registers." id="check4" name="check_null_he_lb" value="check4">
      <label for="check4">Remove HE_LBK (PCIe Loopback)</label><br>
      <input type="checkbox" title="When checked the HE_MEM is replaced with an HE_NULL which ties off the associated VF, leaving a stub with minimal registers." id="check5" name="check_null_he_mem" value="check5">
      <label for="check5">Remove HE_MEM (Read/Write Memory Exerciser)</label><br>
      <input type="checkbox" title="When checked the HE_MEM_TG is replaced with an HE_NULL which ties off the associated VF, leaving a stub with minimal registers." id="check6" name="check_null_he_mem_tg" value="check6">
      <label for="check6">Remove HE_MEM_TG (Pseudo random memory traffic generator)</label><br>
    </fieldset>
    <fieldset>
      <legend>IP Configuration</legend>
      <fieldset>
        <legend>HSSI</legend>
        <select id="ofss_hssi">
          <option value="default">default</option>
          <option value="8x10">8x10 GbE</option>
          <option value="8x25">8x25 GbE</option>
          <option value="2x100">2x100 GbE</option>
          <option value="2x200">2x200 GbE</option>
          <option value="1x400">1x400 GbE</option>
        </select><br>
      </fieldset>
      <fieldset>
        <legend>IOPLL</legend>
        <select id="ofss_iopll">
          <option value="default">default</option>
          <option value="500MHz">500 MHz</option>
          <option value="470MHz">470 MHz</option>
          <option value="350MHz">350 MHz</option>
        </select><br>
      </fieldset>
      <fieldset>
        <legend>PCIe</legend>
        <select id="ofss_pcie">
          <option value="default">default</option>
          <option value="1x16_5pf_3vf">1x16 5PF/3VF</option>
          <option value="1x16_1pf_1vf">1x16 1PF/1VF</option>
          <option value="1x16_2pf_0vf">1x16 2PF/0VF</option>
          <option value="2x8_3pf_3vf">2x8 3PF/3VF</option>
          <option value="2x8_1pf_1vf">2x8 1PF/1VF</option><br>
		  <input type="radio" id="pcie_gen4" name="pcie_gen" value="pcie_gen4" checked>
		  <label for="pcie_gen4">Gen4</label>
          <input type="radio" title="Only the iseries-dk supports PCIe Gen5" id="pcie_gen5" name="pcie_gen" value="pcie_gen5">
          <label for="pcie_gen5">Gen5</label>
        </select><br>
      </fieldset>
    </fieldset>
    <br><input type="submit" value="Submit">
  </form>
  <fieldset>
  <div id="result" style="font-family: monospace; whitespace: pre-wrap; word-wrap: break-word; overflow-wrap: break-word;">Press submit to generate the build command.</div>
  </fieldset>
</div>
<style>
  #myBox {
    border: 1px solid black;
    padding: 10px;
  }
</style>


<script>

var target_board = document.getElementById("select_build_target");
var disable_pr = document.getElementById("check1");
var enable_proot = document.getElementById("check2");
var rm_he_hssi = document.getElementById("check3");
var rm_he_lbk = document.getElementById("check4");
var rm_he_mem = document.getElementById("check5");
var rm_he_mem_tg = document.getElementById("check6");
var rm_hssi_ss = document.getElementById("check8");
var ofss_hssi = document.getElementById("ofss_hssi");
var ofss_hssi_option_default = ofss_hssi.querySelector('option[value="default"]');
var ofss_hssi_option_source = ofss_hssi.querySelector('option[value="source"]');
var ofss_iopll = document.getElementById("ofss_iopll");
var ofss_iopll_option_default = ofss_iopll.querySelector('option[value="default"]');
var ofss_iopll_option_source = ofss_iopll.querySelector('option[value="source"]');
var ofss_pcie = document.getElementById("ofss_pcie");
var ofss_pcie_option_default = ofss_pcie.querySelector('option[value="default"]');
var ofss_pcie_option_source = ofss_pcie.querySelector('option[value="source"]');
var pcie_gen4 = document.getElementById("pcie_gen4");
var pcie_gen5 = document.getElementById("pcie_gen5");

function resize_result () {
  var windowWidth = window.innerWidth;
  var resultFieldset = document.getElementById("result");
  resultFieldset.style.maxWidth = (windowWidth * 0.6) + "px";
}

document.addEventListener("DOMContentLoaded", function() {
  function initialize_check_enable_proot() {
    if (disable_pr.checked) {
	  enable_proot.checked = false;
	  enable_proot.disabled = true;
    } else {
	  enable_proot.disabled = false;
    }
  }

  function limit_target_selection () {
	switch (target_board.value) {
	  case "n6001":
	    ofss_hssi.querySelector('option[value="8x10"]').disabled = false;
		  ofss_hssi.querySelector('option[value="8x25"]').disabled = false;
		  ofss_hssi.querySelector('option[value="2x100"]').disabled = false;
	    ofss_hssi.querySelector('option[value="2x200"]').disabled = true;
		  ofss_hssi.querySelector('option[value="1x400"]').disabled = true;
		  if (ofss_hssi.value == "2x200" | ofss_hssi.value == "1x400") {
			  ofss_hssi.value = "default";
		  }
		
		  ofss_iopll.querySelector('option[value="500MHz"]').disabled = false;
		  ofss_iopll.querySelector('option[value="470MHz"]').disabled = false;
		  ofss_iopll.querySelector('option[value="350MHz"]').disabled = false;
		
		  ofss_pcie.querySelector('option[value="1x16_5pf_3vf"]').disabled = false;
      ofss_pcie.querySelector('option[value="1x16_1pf_1vf"]').disabled = false;
      ofss_pcie.querySelector('option[value="1x16_2pf_0vf"]').disabled = false;
      ofss_pcie.querySelector('option[value="2x8_3pf_3vf"]').disabled = true;
      ofss_pcie.querySelector('option[value="2x8_1pf_1vf"]').disabled = true;
		  if (ofss_pcie.value == "2x8_3pf_3vf" | ofss_pcie.value == "2x8_1pf_1vf") {
			  ofss_pcie.value = "default";
		  }
	  break;
		
	  case "n6000":
	    ofss_hssi.querySelector('option[value="8x10"]').disabled = false;
		  ofss_hssi.querySelector('option[value="8x25"]').disabled = false;
		  ofss_hssi.querySelector('option[value="2x100"]').disabled = false;
	    ofss_hssi.querySelector('option[value="2x200"]').disabled = true;
		  ofss_hssi.querySelector('option[value="1x400"]').disabled = true;
		  if (ofss_hssi.value == "2x200" | ofss_hssi.value == "1x400") {
			ofss_hssi.value = "default";
		  }
		  ofss_iopll.querySelector('option[value="500MHz"]').disabled = true;
		  ofss_iopll.querySelector('option[value="470MHz"]').disabled = true;
		  ofss_iopll.querySelector('option[value="350MHz"]').disabled = false;
		  if (ofss_iopll.value == "500MHz" | ofss_iopll.value == "470MHz") {
		  	ofss_iopll.value = "default";
		  }
		
		  ofss_pcie.querySelector('option[value="1x16_5pf_3vf"]').disabled = false;
      ofss_pcie.querySelector('option[value="1x16_1pf_1vf"]').disabled = true;
      ofss_pcie.querySelector('option[value="1x16_2pf_0vf"]').disabled = true;
      ofss_pcie.querySelector('option[value="2x8_3pf_3vf"]').disabled = true;
      ofss_pcie.querySelector('option[value="2x8_1pf_1vf"]').disabled = true;
		  if (ofss_pcie.value == "1x16_1pf_1vf" | ofss_pcie.value == "1x16_2pf_0vf" | ofss_pcie.value == "2x8_3pf_3vf" | ofss_pcie.value == "2x8_1pf_1vf") {
			ofss_pcie.value = "default";
		  }
	  break;
		
	  case "fseries-dk":
	    ofss_hssi.querySelector('option[value="8x10"]').disabled = true;
		  ofss_hssi.querySelector('option[value="8x25"]').disabled = false;
		  ofss_hssi.querySelector('option[value="2x100"]').disabled = true;
	    ofss_hssi.querySelector('option[value="2x200"]').disabled = true;
		  ofss_hssi.querySelector('option[value="1x400"]').disabled = true;
		  if (ofss_hssi.value == "8x10" | ofss_hssi.value == "2x100" | ofss_hssi.value == "2x200" | ofss_hssi.value == "1x400") {
			  ofss_hssi.value = "default";
		  }

		  ofss_iopll.querySelector('option[value="500MHz"]').disabled = false;
		  ofss_iopll.querySelector('option[value="470MHz"]').disabled = false;
		  ofss_iopll.querySelector('option[value="350MHz"]').disabled = false;
	    
		  ofss_pcie.querySelector('option[value="1x16_5pf_3vf"]').disabled = false;
      ofss_pcie.querySelector('option[value="1x16_1pf_1vf"]').disabled = false;
      ofss_pcie.querySelector('option[value="1x16_2pf_0vf"]').disabled = false;
      ofss_pcie.querySelector('option[value="2x8_3pf_3vf"]').disabled = true;
      ofss_pcie.querySelector('option[value="2x8_1pf_1vf"]').disabled = true;
		  if (ofss_pcie.value == "2x8_3pf_3vf" | ofss_pcie.value == "2x8_1pf_1vf") {
			  ofss_pcie.value = "default";
		  }
		break;
		
	  case "iseries-dk":
	    ofss_hssi.querySelector('option[value="8x10"]').disabled = true;
		  ofss_hssi.querySelector('option[value="8x25"]').disabled = false;
		  ofss_hssi.querySelector('option[value="2x100"]').disabled = true;
	    ofss_hssi.querySelector('option[value="2x200"]').disabled = false;
		  ofss_hssi.querySelector('option[value="1x400"]').disabled = false;
		  if (ofss_hssi.value == "8x10" | ofss_hssi.value == "2x100") {
			  ofss_hssi.value = "default";
		  }

		  ofss_iopll.querySelector('option[value="500MHz"]').disabled = false;
		  ofss_iopll.querySelector('option[value="470MHz"]').disabled = false;
		  ofss_iopll.querySelector('option[value="350MHz"]').disabled = false;
	    
	    if (pcie_gen4.checked == true) {
        ofss_pcie.querySelector('option[value="1x16_5pf_3vf"]').disabled = false;
        ofss_pcie.querySelector('option[value="1x16_1pf_1vf"]').disabled = true;
        ofss_pcie.querySelector('option[value="1x16_2pf_0vf"]').disabled = true;
        ofss_pcie.querySelector('option[value="2x8_3pf_3vf"]').disabled = true;
        ofss_pcie.querySelector('option[value="2x8_1pf_1vf"]').disabled = true;
		    if (ofss_pcie.value != "1x16_5pf_3vf") {
		  	  ofss_pcie.value = "default";
		    }
	    }
	    else {
	      ofss_pcie.querySelector('option[value="1x16_5pf_3vf"]').disabled = false;
        ofss_pcie.querySelector('option[value="1x16_1pf_1vf"]').disabled = false;
        ofss_pcie.querySelector('option[value="1x16_2pf_0vf"]').disabled = false;
        ofss_pcie.querySelector('option[value="2x8_3pf_3vf"]').disabled = false;
        ofss_pcie.querySelector('option[value="2x8_1pf_1vf"]').disabled = false;
	    }
		break;
	}
  }
  
  function handle_pcie_gen () {
    switch (target_board.value) {
	  case "n6001":
		  pcie_gen5.disabled = true;
		  pcie_gen4.disabled = false;
		  pcie_gen4.checked = true;
	  break;
	  
	  case "n6000":
	    pcie_gen5.disabled = true;
		  pcie_gen4.disabled = false;
		  pcie_gen4.checked = true;
	  break;
	  
	  case "fseries-dk":
	    pcie_gen5.disabled = true;
		  pcie_gen4.disabled = false;
		  pcie_gen4.checked = true;
	  break;
	  
	  case "iseries-dk":
	    if (ofss_pcie.value == "source") {
		    pcie_gen4.disabled = true;
		    pcie_gen5.disabled = true;
		    pcie_gen4.checked = false;
		    pcie_gen5.checked = false;
		  }
		  else if (ofss_pcie.value == "default") {
		    pcie_gen4.disabled = true;
		    pcie_gen5.disabled = false;
		    pcie_gen4.checked = false;
		    pcie_gen5.checked = true;
		  }
		  else if (ofss_pcie.value == "1x16_5pf_3vf") {
	      pcie_gen5.disabled = false;
		    pcie_gen4.disabled = false;
		    if (!pcie_gen4.checked & !pcie_gen5.checked) {
		      pcie_gen5.checked = true;
		    }
		  }
		  else {
		    pcie_gen5.disabled = false;
		    pcie_gen4.disabled = true;
		    pcie_gen5.checked = true;
		    pcie_gen4.checked = false;
		  }
	  break;
	}
	limit_target_selection();
  }

  window.addEventListener('resize', resize_result);
  disable_pr.addEventListener("change", initialize_check_enable_proot);
  target_board.addEventListener("change", handle_pcie_gen);
  ofss_pcie.addEventListener("change", handle_pcie_gen);
  pcie_gen4.addEventListener("change", handle_pcie_gen);
  pcie_gen5.addEventListener("change", handle_pcie_gen);
  initialize_check_enable_proot();
  limit_target_selection();
  handle_pcie_gen();
  resize_result();
  
});

document.getElementById("myForm").addEventListener("submit", function(event) {
  event.preventDefault();
  let target_board_st = document.getElementById("select_build_target").value;
  let disable_pr_st = document.getElementById("check1").checked;
  let enable_proot_st = document.getElementById("check2").checked;
  let rm_he_hssi_st = document.getElementById("check3").checked;
  let rm_he_lbk_st = document.getElementById("check4").checked;
  let rm_he_mem_st = document.getElementById("check5").checked;
  let rm_he_mem_tg_st = document.getElementById("check6").checked;
  let rm_hssi_ss_st = document.getElementById("check8").checked;
  let ofss_hssi_st = document.getElementById("ofss_hssi").value;
  let ofss_iopll_st = document.getElementById("ofss_iopll").value;
  let ofss_pcie_st = document.getElementById("ofss_pcie").value;
  let pcie_gen4_st = document.getElementById("pcie_gen4").checked;
  let pcie_gen5_st = document.getElementById("pcie_gen5").checked;
  let result = "./ofs-common/scripts/common/syn/build_top.sh";

  if (ofss_iopll_st != "default") {
    ofss_iopll_st = "tools/ofss_config/iopll/iopll_" + ofss_iopll_st + ".ofss";
  }

  if (ofss_hssi_st != "default") {
    if (target_board_st == "n6001" | target_board_st == "n6000") {
      ofss_hssi_st = "tools/ofss_config/hssi/hssi_" + ofss_hssi_st + ".ofss";
    }
    else if (target_board_st == "fseries-dk" | target_board_st == "iseries-dk") {
      ofss_hssi_st = "tools/ofss_config/hssi/hssi_" + ofss_hssi_st + "_ftile.ofss";
    }
  }
  
  if (ofss_pcie_st != "default") {
    if (ofss_pcie_st == "1x16_5pf_3vf") {
      if (target_board_st == "n6000") {
        ofss_pcie_st = "tools/ofss_config/pcie/pcie_host_n6000.ofss";
      }
	  else if (target_board_st == "iseries-dk" & pcie_gen4_st) {
		ofss_pcie_st = "tools/ofss_config/pcie/pcie_host_gen4.ofss";
	  }
      else {
        ofss_pcie_st = "tools/ofss_config/pcie/pcie_host.ofss";
      }
    }
    else if (ofss_pcie_st == "1x16_1pf_1vf") {
      ofss_pcie_st = "tools/ofss_config/pcie/pcie_host_1pf_1vf.ofss";
    }
    else if (ofss_pcie_st == "1x16_2pf_0vf") {
      ofss_pcie_st = "tools/ofss_config/pcie/pcie_host_2pf.ofss";
    }
    else if (ofss_pcie_st == "2x8_3pf_3vf") {
      ofss_pcie_st = "tools/ofss_config/pcie/pcie_host_2link.ofss";
    }
    else if (ofss_pcie_st == "2x8_1pf_1vf") {
      ofss_pcie_st = "tools/ofss_config/pcie/pcie_host_2link_1pf_1vf.ofss";
    }
  }

  if (enable_proot_st) {
    result += " -p";
  }

  if (ofss_hssi_st != "default" | ofss_iopll_st != "default" | ofss_pcie_st != "default") {
    result += " --ofss ";
    if (ofss_hssi_st != "default" & (ofss_iopll_st != "default" | ofss_pcie_st != "default")) {
      result += ofss_hssi_st + ",";
    }
    else if (ofss_hssi_st != "default") {
      result += ofss_hssi_st;
    }
    if (ofss_iopll_st != "default" & ofss_pcie_st != "default") {
      result += ofss_iopll_st + ",";
    }
    else if (ofss_iopll_st != "default") {
      result += ofss_iopll_st;
    }
    if (ofss_pcie_st != "default") {
      result += ofss_pcie_st;
    }
  }

  result += " " + target_board_st;

  if (disable_pr_st | rm_he_hssi_st | rm_he_lbk_st | rm_he_mem_st | rm_he_mem_tg_st | rm_hssi_ss_st) {
    result += ":";
    if (disable_pr_st & (rm_he_hssi_st | rm_he_lbk_st | rm_he_mem_st | rm_he_mem_tg_st | rm_hssi_ss_st)) {
      result += "flat,";
    } else if (disable_pr_st) {
      result += "flat";
    }
    if (rm_he_hssi_st & (rm_he_lbk_st | rm_he_mem_st | rm_he_mem_tg_st | rm_hssi_ss_st)) {
      result += "null_he_hssi,";
    } else if (rm_he_hssi_st) {
      result += "null_he_hssi";
    }
    if (rm_he_lbk_st & (rm_he_mem_st | rm_he_mem_tg_st | rm_hssi_ss_st)) {
      result += "null_he_lb,";
    } else if (rm_he_lbk_st) {
      result += "null_he_lb";
    }
    if (rm_he_mem_st & (rm_he_mem_tg_st | rm_hssi_ss_st)) {
      result += "null_he_mem,";
    } else if (rm_he_mem_st) {
      result += "null_he_mem";
    }
    if (rm_he_mem_tg_st & rm_hssi_ss_st) {
      result += "null_he_mem_tg,";
    } else if (rm_he_mem_tg_st) {
      result += "null_he_mem_tg";
    }
    if (rm_hssi_ss_st) {
      result += "no_hssi";
    }
  }

  result += " work_" + target_board_st;
  
  resize_result();

  document.getElementById("result").innerText = result;
  document.getElementById("result").style.fontFamily = "monospace";
  document.getElementById("result").style.whiteSpace = "pre-wrap";
  document.getElementById("result").style.wordWrap = "break-word";
  document.getElementById("result").style.overflowWrap = "break-word";
  
});
</script>