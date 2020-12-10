"use strict";

var siglum;
const siglumRe = /^((Rdz|Wj|Kpł|Lb|Pwt|Joz|Sdz|Rt|1Sm|2Sm|1Krl|2Krl|1Krn|2Krn|Ezd|Ne|Tb|Jdt|Est|1Mch|2Mch|Hi|Ps|Prz|Koh|Pnp|Mdr|Syr|Iz|Jr|Lm|Ba|Ez|Dn|Oz|Jl|Am|Ab|Jon|Mi|Na|Ha|So|Ag|Za|Ml|Mt|Mk|Łk|J|Dz|Rz|1Kor|2Kor|Ga|Ef|Flp|Kol|1Tes|2Tes|1Tm|2Tm|Tt|Flm|Hbr|Jk|1P|2P|1J|2J|3J|Jud|Ap))( [\d]{1,2}(; [\d]{1,2})*((-[\d]{1,2})|(,([\d]{1,2}((n{1,2})|(-[\d]{1,2}))?(\. ([\d]{1,2}((n{1,2})|(-[\d]{1,2}))?))*)))?((; [\d]{1,2})+((-[\d]{1,2})|(,([\d]{1,2}((n{1,2})|(-[\d]{1,2}))?(\. ([\d]{1,2}((n{1,2})|(-[\d]{1,2}))?))*)))?)*)?$/;

!(siglum.match(siglumRe) == null);